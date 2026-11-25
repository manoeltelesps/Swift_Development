import Foundation

/// A finished session, handed off by `AudioCaptureService` for `SessionView` to
/// persist into SwiftData. Plain value type — persistence is the View's job, not
/// the capture service's.
struct SessionRecording: Equatable {
    struct RateSample: Equatable {
        let elapsedSec: Double
        let articulationRate: Double
    }

    let startedAt: Date
    let durationSec: Double
    let baselineSyllablesPerSecond: Double
    let samples: [RateSample]
    let alertElapsedTimes: [Double]
    let pauseDensity: Double

    var averageArticulationRate: Double {
        guard !samples.isEmpty else { return 0 }
        return samples.map(\.articulationRate).reduce(0, +) / Double(samples.count)
    }
}
