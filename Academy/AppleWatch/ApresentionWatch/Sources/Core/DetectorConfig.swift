import Foundation

/// All tunable parameters for the syllable-nucleus detector, in one place so the
/// Fase 0 harness can sweep them without rebuilding any app target.
public struct DetectorConfig: Sendable {
    public var frameMs: Double
    public var smoothingMs: Double
    public var valleyDepthDB: Double
    public var minPeakAboveFloorDB: Double
    public var minPeakDistanceMs: Double
    public var analysisWindowSec: Double
    public var sustainedBreachSec: Double
    public var alertCooldownSec: Double
    public var ceilingMultiplier: Double
    public var syllablesPerWord: Double

    public init(
        frameMs: Double = 10,
        smoothingMs: Double = 50,
        valleyDepthDB: Double = 3.0,
        minPeakAboveFloorDB: Double = 6.0,
        minPeakDistanceMs: Double = 100,
        analysisWindowSec: Double = 8.0,
        sustainedBreachSec: Double = 8.0,
        alertCooldownSec: Double = 40.0,
        ceilingMultiplier: Double = 1.15,
        syllablesPerWord: Double = 2.3
    ) {
        self.frameMs = frameMs
        self.smoothingMs = smoothingMs
        self.valleyDepthDB = valleyDepthDB
        self.minPeakAboveFloorDB = minPeakAboveFloorDB
        self.minPeakDistanceMs = minPeakDistanceMs
        self.analysisWindowSec = analysisWindowSec
        self.sustainedBreachSec = sustainedBreachSec
        self.alertCooldownSec = alertCooldownSec
        self.ceilingMultiplier = ceilingMultiplier
        self.syllablesPerWord = syllablesPerWord
    }

    public static let `default` = DetectorConfig()
}
