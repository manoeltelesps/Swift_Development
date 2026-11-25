import Foundation

/// Fase 3's second calibration output: given a recording of known syllable count
/// (the person reading the embedded calibration text), search for the
/// `valleyDepthDB` / `minPeakAboveFloorDB` pair that gets the detector closest to
/// that hand-counted gabarito — tuned to this person's voice and room, not a
/// generic default.
public enum ThresholdCalibrator {
    public struct Result {
        public let config: DetectorConfig
        public let detectedCount: Int
        public let errorCount: Int
    }

    public static func calibrate(
        samples: [Float],
        sampleRate: Double,
        expectedSyllableCount: Int,
        baseConfig: DetectorConfig = .default,
        valleyDepthCandidates: [Double] = [1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 5.0, 6.0],
        floorMarginCandidates: [Double] = [3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
    ) -> Result {
        var best: Result?

        for valleyDepth in valleyDepthCandidates {
            for floorMargin in floorMarginCandidates {
                var candidate = baseConfig
                candidate.valleyDepthDB = valleyDepth
                candidate.minPeakAboveFloorDB = floorMargin

                let detected = SpeechRateDetector.detect(samples: samples, sampleRate: sampleRate, config: candidate).syllableCount
                let error = abs(detected - expectedSyllableCount)

                if best == nil || error < best!.errorCount {
                    best = Result(config: candidate, detectedCount: detected, errorCount: error)
                }
            }
        }

        return best ?? Result(config: baseConfig, detectedCount: 0, errorCount: expectedSyllableCount)
    }
}
