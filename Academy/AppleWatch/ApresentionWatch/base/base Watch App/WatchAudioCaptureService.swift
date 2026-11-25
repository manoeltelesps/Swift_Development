import AVFoundation
import Combine
import Core

/// Standalone speech-rate capture on the Watch: mic tap, downsample to 16kHz mono,
/// an 8s sliding window into `SpeechRateDetector`, `AlertPolicy` triggering the
/// haptic directly — no round trip to the iPhone needed for the core loop.
///
/// Works while this app is in the foreground. It does not yet survive the screen
/// turning off — that needs the Background Modes (audio) capability, which this
/// build doesn't request, on purpose: getting continuous background recording
/// right needs iterative testing on the real device that isn't possible here.
@MainActor
final class WatchAudioCaptureService: NSObject, ObservableObject {
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
    private var alertPolicy: AlertPolicy

    // Guards against a second start() installing a tap while the first one is
    // still mid-flight (e.g. a double-tap while waiting on the permission
    // prompt) — AVAudioEngine crashes with "nullptr == Tap()" if installTap is
    // called twice on the same bus without a removeTap in between.
    private var isStarting = false
    private var tapBufferCount = 0
    private var notificationTokens: [NSObjectProtocol] = []
    private var isReinstallingTap = false
    private var lastTapSampleRate: Double = 0

    override init() {
        self.windowCapacity = Int(config.analysisWindowSec * 16_000)
        self.alertPolicy = AlertPolicy(baselineSyllablesPerSecond: CalibrationStore.baselineSyllablesPerSecond, config: config)
        super.init()
    }

    func start() async throws {
        guard !isRunning, !isStarting else { return }
        isStarting = true
        defer { isStarting = false }

        guard await requestMicPermission() else { throw CaptureError.permissionDenied }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement)
        try session.setActive(true)

        // Prepare before reading the input format: on watchOS the mic route can
        // still be settling right after setActive(true), and a tap installed
        // against a pre-settlement format has been observed to silently stop
        // delivering buffers after the first one (engine.isRunning stays true,
        // but the hardware side goes quiet). installTap() re-reads the format
        // fresh, and reinstalls again on any later route change.
        engine.prepare()

        windowSamples.removeAll()
        tapBufferCount = 0
        alertPolicy = AlertPolicy(baselineSyllablesPerSecond: CalibrationStore.baselineSyllablesPerSecond, config: config)
        installDiagnosticObservers(session: session)

        try installTap()

        try engine.start()
        isRunning = true
        startUpdateTimer()
    }

    func stop() {
        guard isRunning else { return }
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        updateTimer?.invalidate()
        updateTimer = nil
        windowSamples.removeAll()
        isRunning = false
        lastTapSampleRate = 0
        removeDiagnosticObservers()
    }

    private func installTap() throws {
        // Reentrancy guard: removeTap/installTap can itself provoke another
        // route-change notification, which (without this) would call back into
        // installTap() again — a feedback loop that pins the main thread and
        // makes the whole UI, including the start/stop button, stop responding.
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
                self?.tapBufferCount += 1
                self?.append(samples)
            }
        }
        print("[WatchAudioCaptureService] tap installed, format=\(inputFormat)")
    }

    private func installDiagnosticObservers(session: AVAudioSession) {
        let center = NotificationCenter.default
        notificationTokens.append(center.addObserver(forName: AVAudioSession.interruptionNotification, object: session, queue: .main) { note in
            let typeValue = (note.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt).flatMap(AVAudioSession.InterruptionType.init)
            print("[WatchAudioCaptureService] AVAudioSession interruption: \(String(describing: typeValue))")
        })
        notificationTokens.append(center.addObserver(forName: AVAudioSession.routeChangeNotification, object: session, queue: .main) { [weak self] note in
            let reasonValue = (note.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt).flatMap(AVAudioSession.RouteChangeReason.init)
            print("[WatchAudioCaptureService] AVAudioSession route change: \(String(describing: reasonValue)) — reinstalling tap")
            guard let self, self.isRunning || self.isStarting else { return }
            try? self.installTap()
        })
        notificationTokens.append(center.addObserver(forName: .AVAudioEngineConfigurationChange, object: engine, queue: .main) { [weak self] _ in
            print("[WatchAudioCaptureService] AVAudioEngine configuration changed, isRunning=\(self?.engine.isRunning ?? false)")
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
        guard !windowSamples.isEmpty else {
            print("[WatchAudioCaptureService] recompute(): windowSamples empty, no tap data yet")
            return
        }
        let result = SpeechRateDetector.detect(samples: windowSamples, sampleRate: targetFormat.sampleRate, config: config)
        let peak = windowSamples.map { abs($0) }.max() ?? 0
        print(String(
            format: "[WatchAudioCaptureService] buffers=%d engineRunning=%@ samples=%d peak=%.4f noiseFloor=%.1fdB nuclei=%d speakingSec=%.2f rate=%.2f ceiling=%.2f",
            tapBufferCount, engine.isRunning ? "YES" : "NO", windowSamples.count, peak, result.noiseFloorDB, result.syllableCount, result.speakingTimeSec, result.articulationRate, alertPolicy.ceiling
        ))
        if alertPolicy.evaluate(articulationRate: result.articulationRate, at: ProcessInfo.processInfo.systemUptime) {
            print("[WatchAudioCaptureService] ALERT FIRED")
            HapticService.playAlert()
        }
    }

    private func requestMicPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
}
