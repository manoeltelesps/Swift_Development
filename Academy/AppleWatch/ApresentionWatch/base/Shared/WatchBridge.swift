import Foundation
import WatchConnectivity

enum WatchMessageKey {
    static let type = "type"
}

enum WatchMessageType: String {
    /// iPhone → Watch: AlertPolicy fired, play the haptic.
    case alertTriggered
    /// iPhone → Watch: capture session state, for the "sessão ativa" indicator.
    case sessionStarted
    case sessionStopped
    /// Watch → iPhone: user tapped the Watch's start/stop button.
    case requestStartSession
    case requestStopSession
}

extension Dictionary where Key == String, Value == Any {
    var watchMessageType: WatchMessageType? {
        (self[WatchMessageKey.type] as? String).flatMap(WatchMessageType.init)
    }
}

enum WatchMessage {
    static func payload(_ type: WatchMessageType) -> [String: Any] {
        [WatchMessageKey.type: type.rawValue]
    }
}

/// Thin WCSession wrapper compiled into both the iOS and watchOS targets. Kept off
/// the main actor deliberately — WCSessionDelegate callbacks arrive on an arbitrary
/// queue — so callers are responsible for hopping back to their own actor before
/// touching UI state from `onMessageReceived`.
nonisolated final class WatchBridge: NSObject {
    var onMessageReceived: (([String: Any]) -> Void)?
    /// Fires when a send that looked reachable still failed in flight (e.g. the
    /// counterpart app got backgrounded mid-send). Callers that need user-facing
    /// feedback (the Watch's start/stop button) should listen for this; the alert
    /// haptic path deliberately doesn't.
    var onSendFailure: ((Error) -> Void)?

    private let session: WCSession?

    override init() {
        session = WCSession.isSupported() ? WCSession.default : nil
        super.init()
        session?.delegate = self
        session?.activate()
    }

    var isReachable: Bool {
        session?.isReachable ?? false
    }

    /// Best-effort send. Returns whether the counterpart looked reachable at the
    /// time of sending — callers that need the user to know a send had no chance
    /// of arriving (e.g. "open the iPhone app") should check this; the alert
    /// haptic path ignores it on purpose, per the spec's silent-degradation rule.
    @discardableResult
    func send(_ message: [String: Any]) -> Bool {
        guard let session, session.isReachable else { return false }
        session.sendMessage(message, replyHandler: nil) { [weak self] error in
            self?.onSendFailure?(error)
        }
        return true
    }
}

extension WatchBridge: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        onMessageReceived?(message)
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}
