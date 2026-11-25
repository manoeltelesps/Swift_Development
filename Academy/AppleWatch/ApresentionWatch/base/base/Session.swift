import Foundation
import SwiftData

/// A persisted ensaio session, per Fase 6. Only numeric metrics and timestamps —
/// no audio, per the spec's privacy rule.
@Model
final class Session {
    var startedAt: Date
    var durationSec: Double
    var baselineSyllablesPerSecond: Double
    var pauseDensity: Double

    @Relationship(deleteRule: .cascade, inverse: \SessionRateSample.session)
    var rateSamples: [SessionRateSample] = []

    @Relationship(deleteRule: .cascade, inverse: \SessionAlertMarker.session)
    var alertMarkers: [SessionAlertMarker] = []

    init(startedAt: Date, durationSec: Double, baselineSyllablesPerSecond: Double, pauseDensity: Double) {
        self.startedAt = startedAt
        self.durationSec = durationSec
        self.baselineSyllablesPerSecond = baselineSyllablesPerSecond
        self.pauseDensity = pauseDensity
    }

    var averageArticulationRate: Double {
        guard !rateSamples.isEmpty else { return 0 }
        return rateSamples.map(\.articulationRate).reduce(0, +) / Double(rateSamples.count)
    }

    convenience init(recording: SessionRecording) {
        self.init(
            startedAt: recording.startedAt,
            durationSec: recording.durationSec,
            baselineSyllablesPerSecond: recording.baselineSyllablesPerSecond,
            pauseDensity: recording.pauseDensity
        )
        rateSamples = recording.samples.map { SessionRateSample(elapsedSec: $0.elapsedSec, articulationRate: $0.articulationRate) }
        alertMarkers = recording.alertElapsedTimes.map { SessionAlertMarker(elapsedSec: $0) }
    }
}

@Model
final class SessionRateSample {
    var elapsedSec: Double
    var articulationRate: Double
    var session: Session?

    init(elapsedSec: Double, articulationRate: Double) {
        self.elapsedSec = elapsedSec
        self.articulationRate = articulationRate
    }
}

@Model
final class SessionAlertMarker {
    var elapsedSec: Double
    var session: Session?

    init(elapsedSec: Double) {
        self.elapsedSec = elapsedSec
    }
}
