import Core
import Foundation

/// Persists the personal baseline (síl/s) across launches. Falls back to
/// `AlertPolicy.assumedDefaultBaseline` until the person adjusts the slider.
enum CalibrationStore {
    private static let baselineKey = "calibration.baselineSyllablesPerSecond"

    static var isCalibrated: Bool {
        UserDefaults.standard.double(forKey: baselineKey) > 0
    }

    static var baselineSyllablesPerSecond: Double {
        let stored = UserDefaults.standard.double(forKey: baselineKey)
        return stored > 0 ? stored : AlertPolicy.assumedDefaultBaseline
    }

    static func save(baselineSyllablesPerSecond: Double) {
        UserDefaults.standard.set(baselineSyllablesPerSecond, forKey: baselineKey)
    }
}
