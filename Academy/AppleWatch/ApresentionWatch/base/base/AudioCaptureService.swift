import AVFoundation
import Combine
import Core

/// Captures mic audio, downsamples to 16kHz mono, and feeds an 8s sliding window
/// (updated every 0.5s) into `SpeechRateDetector`. No audio is ever written to disk.
@MainActor
final class AudioCaptureService: NSObject, ObservableObject {
    enum CaptureError: LocalizedError {
        case permissionDenied
        case converterUnavailable

        var errorDescription: String? {
            switch self {
            case .permissionDenied: return "Permissão de microfone negada."
            case .converterUnavailable: return "Não foi possível configurar a captura de áudio."
            }
        }
    }

    @Published private(set) var isRunning = false
    @Published private(set) var wordsPerMinute: Double = 0
    @Published private(set) var syllablesPerSecond: Double = 0
    @Published private(set) var lastRecording: SessionRecording?

    private let config = DetectorConfig.default
    private let engine = AVAudioEngine()
    private let targetFormat = AVAudioFormat(
        commonFormat: .pcmFormatFloat32,
        sampleRate: 16_000,
        channels: 1,
        interleaved: false
    )!
    private var windowSamples: [Float] = []
    private var updateTimer: Timer?
    private let windowCapacity: Int
    private let watchBridge = WatchBridge()
    private var alertPolicy: AlertPolicy

    // Guards against a second start() installing a tap while the first one is
    // still mid-flight — AVAudioEngine crashes with "nullptr == Tap()" if
    // installTap is called twice on the same bus without a removeTap between.
    private var isStarting = false
    private var notificationTokens: [NSObjectProtocol] = []
    private var isReinstallingTap = false
    private var lastTapSampleRate: Double = 0

    // Fase 6 session bookkeeping, reset on each start().
    private var sessionStartedAt = Date()
    private var sessionStartUptime: TimeInterval = 0
    private var sessionBaseline: Double = 0
    private var rateSamples: [SessionRecording.RateSample] = []
    private var alertElapsedTimes: [Double] = []
    private var sessionSpeakingFrames = 0
    private var sessionTotalFrames = 0

    override init() {
        self.windowCapacity = Int(config.analysisWindowSec * 16_000)
        self.alertPolicy = AlertPolicy(baselineSyllablesPerSecond: CalibrationStore.baselineSyllablesPerSecond, config: config)
        super.init()

        watchBridge.onMessageReceived = { [weak self] message in
            guard let type = message.watchMessageType else { return }
            Task { @MainActor [weak self] in
                self?.handleWatchMessage(type)
            }
        }
    }

    func start() async throws {
        guard !isRunning, !isStarting else { return }
        isStarting = true
        defer { isStarting = false }

        guard await requestMicPermission() else { throw CaptureError.permissionDenied }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement)
        try session.setActive(true)

        // Prepare before installing the tap: a tap installed against a
        // pre-settlement input format can silently stop delivering buffers once
        // the route finishes negotiating (engine.isRunning stays true, but the
        // hardware side goes quiet). installTap() re-reads the format fresh, and
        // reinstalls again on any later route change, as a safety net.
        engine.prepare()

        // Re-read the baseline each start(), so adjusting the slider and then
        // immediately starting a session picks up the new value.
        windowSamples.removeAll()
        sessionBaseline = CalibrationStore.baselineSyllablesPerSecond
        alertPolicy = AlertPolicy(baselineSyllablesPerSecond: sessionBaseline, config: config)

        sessionStartedAt = Date()
        sessionStartUptime = ProcessInfo.processInfo.systemUptime
        rateSamples.removeAll()
        alertElapsedTimes.removeAll()
        sessionSpeakingFrames = 0
        sessionTotalFrames = 0
        installDiagnosticObservers(session: session)

        try installTap()

        try engine.start()
        isRunning = true
        startUpdateTimer()
        watchBridge.send(WatchMessage.payload(.sessionStarted))
    }

    func stop() {
        guard isRunning else { return }
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)

        let durationSec = ProcessInfo.processInfo.systemUptime - sessionStartUptime
        let pauseDensity = sessionTotalFrames > 0
            ? 1.0 - (Double(sessionSpeakingFrames) / Double(sessionTotalFrames))
            : 0
        if durationSec > 0 {
            lastRecording = SessionRecording(
                startedAt: sessionStartedAt,
                durationSec: durationSec,
                baselineSyllablesPerSecond: sessionBaseline,
                samples: rateSamples,
                alertElapsedTimes: alertElapsedTimes,
                pauseDensity: pauseDensity
            )
        }

        updateTimer?.invalidate()
        updateTimer = nil
        windowSamples.removeAll()
        wordsPerMinute = 0
        syllablesPerSecond = 0
        isRunning = false
        lastTapSampleRate = 0
        watchBridge.send(WatchMessage.payload(.sessionStopped))
        removeDiagnosticObservers()
    }

    private func installTap() throws {
        // Reentrancy guard: removeTap/installTap can itself provoke another
        // route-change notification, which (without this) would call back into
        // installTap() again — a feedback loop that pins the main thread.
        guard !isReinstallingTap else { return }
        isReinstallingTap = true
        defer { isReinstallingTap = false }

        let input = engine.inputNode
        let inputFormat = input.outputFormat(forBus: 0)

        // Skip if nothing actually changed — avoids reinstalling in response to
        // a route-change notification that installTap() itself just triggered.
        guard inputFormat.sampleRate != lastTapSampleRate else { return }
        lastTapSampleRate = inputFormat.sampleRate

        guard let converter = AudioFormatConverter(inputFormat: inputFormat, targetFormat: targetFormat) else {
            throw CaptureError.converterUnavailable
        }

        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 2048, format: inputFormat) { [weak self] buffer, _ in
            let samples = converter.process(buffer)
            guard !samples.isEmpty else { return }
            Task { @MainActor [weak self] in
                self?.append(samples)
            }
        }
    }

    private func installDiagnosticObservers(session: AVAudioSession) {
        let center = NotificationCenter.default
        notificationTokens.append(center.addObserver(forName: AVAudioSession.routeChangeNotification, object: session, queue: .main) { [weak self] _ in
            guard let self, self.isRunning || self.isStarting else { return }
            try? self.installTap()
        })
    }

    private func removeDiagnosticObservers() {
        notificationTokens.forEach { NotificationCenter.default.removeObserver($0) }
        notificationTokens.removeAll()
    }

    private func append(_ samples: [Float]) {
        windowSamples.append(contentsOf: samples)
        if windowSamples.count > windowCapacity {
            windowSamples.removeFirst(windowSamples.count - windowCapacity)
        }
    }

    private func startUpdateTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.recompute() }
        }
    }

    private func recompute() {
        guard !windowSamples.isEmpty else { return }
        let result = SpeechRateDetector.detect(samples: windowSamples, sampleRate: targetFormat.sampleRate, config: config)
        syllablesPerSecond = result.articulationRate
        wordsPerMinute = result.articulationRate * 60 / config.syllablesPerWord

        let elapsed = ProcessInfo.processInfo.systemUptime - sessionStartUptime
        rateSamples.append(SessionRecording.RateSample(elapsedSec: elapsed, articulationRate: result.articulationRate))

        // Pause density bookkeeping: classify only the newest ~0.5s of the sliding
        // window each tick, so overlapping windows never double-count a frame.
        let framesPerTick = max(1, Int(500.0 / config.frameMs))
        let recentMask = result.speechMask.suffix(framesPerTick)
        sessionSpeakingFrames += recentMask.filter { $0 }.count
        sessionTotalFrames += recentMask.count

        if alertPolicy.evaluate(articulationRate: result.articulationRate, at: ProcessInfo.processInfo.systemUptime) {
            alertElapsedTimes.append(elapsed)
            watchBridge.send(WatchMessage.payload(.alertTriggered))
        }
    }

    private func requestMicPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }

    private func handleWatchMessage(_ type: WatchMessageType) {
        switch type {
        case .requestStartSession:
            guard !isRunning else { return }
            Task { try? await self.start() }
        case .requestStopSession:
            stop()
        case .sessionStarted, .sessionStopped, .alertTriggered:
            break // these three are iPhone → Watch only
        }
    }
}
