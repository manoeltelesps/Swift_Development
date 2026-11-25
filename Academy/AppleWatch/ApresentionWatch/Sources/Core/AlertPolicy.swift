import Foundation

/// Decides when to trigger the wrist haptic. Pure state machine, driven by whatever
/// cadence the caller samples articulation rate at (live capture ticks every 0.5s,
/// but this doesn't assume that) — no UI, no WatchConnectivity.
public struct AlertPolicy {
    /// Baseline to assume before Fase 3 calibration exists, per the spec's plan to
    /// test the end-to-end alert loop before building real calibration.
    public static let assumedDefaultBaseline: Double = 5.5

    public let config: DetectorConfig
    public private(set) var baselineSyllablesPerSecond: Double

    private var breachStartTime: TimeInterval?
    private var lastAlertTime: TimeInterval?

    public init(baselineSyllablesPerSecond: Double, config: DetectorConfig = .default) {
        self.baselineSyllablesPerSecond = baselineSyllablesPerSecond
        self.config = config
    }

    public var ceiling: Double {
        baselineSyllablesPerSecond * config.ceilingMultiplier
    }

    public mutating func setBaseline(_ syllablesPerSecond: Double) {
        baselineSyllablesPerSecond = syllablesPerSecond
        breachStartTime = nil
    }

    /// Feed the current articulation rate and its timestamp. Returns `true` exactly
    /// on the tick where an alert should fire.
    @discardableResult
    public mutating func evaluate(articulationRate: Double, at time: TimeInterval) -> Bool {
        guard articulationRate > ceiling else {
            breachStartTime = nil
            return false
        }

        let start = breachStartTime ?? time
        breachStartTime = start

        guard time - start >= config.sustainedBreachSec else { return false }
        if let last = lastAlertTime, time - last < config.alertCooldownSec { return false }

        lastAlertTime = time
        return true
    }
}
