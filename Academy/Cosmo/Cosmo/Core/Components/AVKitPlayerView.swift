import SwiftUI
import AVKit

// Esta view faz a "ponte" entre o player nativo do iOS (AVPlayerViewController) e o SwiftUI.
struct AVKitPlayerView: UIViewControllerRepresentable {
    let videoURL: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.player?.play() // Adicionado para começar a tocar automaticamente
        controller.entersFullScreenWhenPlaybackBegins = true
        controller.exitsFullScreenWhenPlaybackEnds = true
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

