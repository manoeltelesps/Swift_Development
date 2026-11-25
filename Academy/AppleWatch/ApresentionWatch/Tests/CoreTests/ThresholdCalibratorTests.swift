import XCTest
@testable import Core

final class ThresholdCalibratorTests: XCTestCase {
    /// Hann-windowed sine bursts separated by silence — same shape as the
    /// Fixtures/ synthetic .wav generator, built in-process so this test needs no
    /// external files.
    private func makeBurstSamples(count: Int, sampleRate: Double = 16_000, freq: Double = 180) -> [Float] {
        var samples: [Float] = []

        func appendSilence(_ dur: Double) {
            samples.append(contentsOf: [Float](repeating: 0, count: Int(sampleRate * dur)))
        }
        func appendBurst(_ dur: Double) {
            let n = Int(sampleRate * dur)
            for i in 0..<n {
                let t = Double(i) / sampleRate
                let window = n > 1 ? 0.5 * (1 - cos(2 * .pi * Double(i) / Double(n - 1))) : 1.0
                samples.append(Float(0.6 * window * sin(2 * .pi * freq * t)))
            }
        }

        appendSilence(0.3)
        for _ in 0..<count {
            appendBurst(0.18)
            appendSilence(0.35)
        }
        return samples
    }

    func testCalibrateFindsThresholdsThatMatchTheGabarito() {
        let samples = makeBurstSamples(count: 8)
        // A deliberately bad starting config (excessive valley depth suppresses
        // real peaks) forces the grid search to actually search.
        var badBase = DetectorConfig.default
        badBase.valleyDepthDB = 20

        let result = ThresholdCalibrator.calibrate(
            samples: samples,
            sampleRate: 16_000,
            expectedSyllableCount: 8,
            baseConfig: badBase
        )

        XCTAssertEqual(result.detectedCount, 8)
        XCTAssertEqual(result.errorCount, 0)
    }

    func testCalibrateNeverReturnsWorseThanTheBestGridCandidate() {
        let samples = makeBurstSamples(count: 5)
        let expected = 5

        let result = ThresholdCalibrator.calibrate(samples: samples, sampleRate: 16_000, expectedSyllableCount: expected)

        var bruteForceBestError = Int.max
        for valleyDepth in stride(from: 1.5, through: 6.0, by: 0.5) {
            for floorMargin in stride(from: 3.0, through: 10.0, by: 1.0) {
                var config = DetectorConfig.default
                config.valleyDepthDB = valleyDepth
                config.minPeakAboveFloorDB = floorMargin
                let detected = SpeechRateDetector.detect(samples: samples, sampleRate: 16_000, config: config).syllableCount
                bruteForceBestError = min(bruteForceBestError, abs(detected - expected))
            }
        }

        XCTAssertEqual(result.errorCount, bruteForceBestError)
    }
}
