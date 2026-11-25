import Foundation

/// Result of running the detector over one buffer: syllable nuclei plus the derived
/// speaking-time metrics needed for the articulation rate and pause density.
public struct SyllableDetectionResult {
    public let nuclei: [Int]
    public let speechMask: [Bool]
    public let frameMs: Double
    public let noiseFloorDB: Double

    public var syllableCount: Int { nuclei.count }

    public var speakingTimeSec: Double {
        Double(speechMask.filter { $0 }.count) * frameMs / 1000.0
    }

    public var totalTimeSec: Double {
        Double(speechMask.count) * frameMs / 1000.0
    }

    /// % of total time spent in silence.
    public var pauseDensity: Double {
        guard totalTimeSec > 0 else { return 0 }
        return 1.0 - (speakingTimeSec / totalTimeSec)
    }

    /// Syllables per second of speaking time (excludes pauses) — the metric that
    /// drives the alert policy, per the spec's distinction between raw and
    /// articulation rate.
    public var articulationRate: Double {
        guard speakingTimeSec > 0 else { return 0 }
        return Double(syllableCount) / speakingTimeSec
    }
}

/// Pure syllable-nucleus detector. No UI, no AVFoundation — takes PCM samples in,
/// returns nuclei indices out, so it can be developed and scored entirely against
/// the Fase 0 harness.
public enum SpeechRateDetector {
    public static func detect(samples: [Float], sampleRate: Double, config: DetectorConfig = .default) -> SyllableDetectionResult {
        let envelope = EnvelopeExtractor.extract(samples: samples, sampleRate: sampleRate, config: config)
        let speechMask = VoiceActivityDetector.detect(envelope: envelope, config: config)
        let frameSize = max(1, Int(sampleRate * config.frameMs / 1000.0))
        let minDistanceFrames = max(1, Int(config.minPeakDistanceMs / config.frameMs))

        let env = envelope.dbValues
        var nuclei: [Int] = []

        guard env.count > 2 else {
            return SyllableDetectionResult(nuclei: [], speechMask: speechMask, frameMs: config.frameMs, noiseFloorDB: envelope.noiseFloorDB)
        }

        for i in 1..<(env.count - 1) {
            guard env[i] > env[i - 1], env[i] >= env[i + 1] else { continue }
            guard env[i] > envelope.noiseFloorDB + config.minPeakAboveFloorDB else { continue }
            guard isVoiced(samples: samples, frameIndex: i, frameSize: frameSize) else { continue }

            if let last = nuclei.last {
                guard (i - last) >= minDistanceFrames else { continue }
                let valley = env[last...i].min() ?? env[i]
                guard min(env[last], env[i]) - valley >= config.valleyDepthDB else { continue }
            }
            nuclei.append(i)
        }

        return SyllableDetectionResult(nuclei: nuclei, speechMask: speechMask, frameMs: config.frameMs, noiseFloorDB: envelope.noiseFloorDB)
    }

    /// Cheap voicing proxy: voiced syllable nuclei have low zero-crossing rate at high
    /// energy. Filters out non-speech transients (paper, coughs, table taps) that would
    /// otherwise look like energy peaks. Not exposed as a config knob — the spec's
    /// calibration phase only tunes `valleyDepthDB` and the noise floor.
    private static func isVoiced(samples: [Float], frameIndex: Int, frameSize: Int) -> Bool {
        let start = frameIndex * frameSize
        let end = min(start + frameSize, samples.count)
        guard end - start > 1 else { return false }

        var crossings = 0
        for j in (start + 1)..<end {
            if (samples[j] >= 0) != (samples[j - 1] >= 0) {
                crossings += 1
            }
        }
        let zcr = Double(crossings) / Double(end - start)
        return zcr < 0.35
    }
}
