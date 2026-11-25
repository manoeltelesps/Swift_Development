import Combine
import Foundation

@MainActor
final class WatchSessionViewModel: ObservableObject {
    @Published private(set) var isRunning = false
    @Published var errorMessage: String?

    private let audioCapture = WatchAudioCaptureService()

    init() {
        audioCapture.$isRunning.assign(to: &$isRunning)
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
