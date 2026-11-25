import WatchKit

/// A single haptic pattern. Per the spec: under pressure nobody distinguishes two
/// different patterns, so there's no point offering more than one.
enum HapticService {
    static func playAlert() {
        WKInterfaceDevice.current().play(.notification)
    }
}
