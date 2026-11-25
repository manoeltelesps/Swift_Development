import Combine
import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    @Published private(set) var isRunning = false
    @Published private(set) var wordsPerMinute: Double = 0
    @Published private(set) var lastRecording: SessionRecording?
    @Published var errorMessage: String?

    private let audioCapture: AudioCaptureService

    init(audioCapture: AudioCaptureService) {
        self.audioCapture = audioCapture
        audioCapture.$isRunning.assign(to: &$isRunning)
        audioCapture.$wordsPerMinute.assign(to: &$wordsPerMinute)
        audioCapture.$lastRecording.assign(to: &$lastRecording)
    }

    func toggleSession() {
        if isRunning {
            audioCapture.stop()
        } else {
            errorMessage = nil
            Task {
                do {
                    try await audioCapture.start()
                } catch {
                    errorMessage = (error as? LocalizedError)?.errorDescription ?? "\(error)"
                }
            }
        }
    }
}
