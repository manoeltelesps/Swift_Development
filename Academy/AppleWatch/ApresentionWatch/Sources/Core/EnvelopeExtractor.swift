import Foundation

/// Per-frame energy envelope in dB, smoothed, plus an adaptive noise floor estimate.
public struct Envelope {
    public let dbValues: [Double]
    public let noiseFloorDB: Double
    public let frameMs: Double
}

public enum EnvelopeExtractor {
    /// Frames the signal at `config.frameMs`, computes RMS in dB per frame, smooths
    /// with a centered moving average (~`config.smoothingMs`), and estimates a noise
    /// floor as the median of frames below the 20th energy percentile.
    ///
    /// The noise floor is computed once over the whole buffer, which is fine for the
    /// Fase 0/1 offline harness. Fase 2's live capture needs a rolling estimate instead.
    public static func extract(samples: [Float], sampleRate: Double, config: DetectorConfig) -> Envelope {
        let frameSize = max(1, Int(sampleRate * config.frameMs / 1000.0))
        var rawDB: [Double] = []
        rawDB.reserveCapacity(samples.count / frameSize + 1)

        var i = 0
        while i < samples.count {
            let end = min(i + frameSize, samples.count)
            var sumSq: Double = 0
            for j in i..<end {
                let v = Double(samples[j])
                sumSq += v * v
            }
            let rms = sqrt(sumSq / Double(end - i))
            rawDB.append(20 * log10(max(rms, 1e-9)))
            i += frameSize
        }

        let smoothFrames = max(1, Int(config.smoothingMs / config.frameMs))
        let smoothed = centeredMovingAverage(rawDB, window: smoothFrames)
        let noiseFloor = adaptiveNoiseFloor(smoothed)

        return Envelope(dbValues: smoothed, noiseFloorDB: noiseFloor, frameMs: config.frameMs)
    }

    private static func centeredMovingAverage(_ values: [Double], window: Int) -> [Double] {
        guard window > 1, !values.isEmpty else { return values }
        let half = window / 2
        var result = [Double](repeating: 0, count: values.count)
        for i in 0..<values.count {
            let lo = max(0, i - half)
            let hi = min(values.count, i + half + 1)
            var sum: Double = 0
            for j in lo..<hi { sum += values[j] }
            result[i] = sum / Double(hi - lo)
        }
        return result
    }

    private static func adaptiveNoiseFloor(_ values: [Double]) -> Double {
        guard !values.isEmpty else { return -90 }
        let sorted = values.sorted()
        let p20Index = max(0, Int(Double(sorted.count - 1) * 0.2))
        let threshold = sorted[p20Index]
        let belowP20 = values.filter { $0 <= threshold }
        return median(belowP20.isEmpty ? sorted : belowP20)
    }

    private static func median(_ values: [Double]) -> Double {
        let sorted = values.sorted()
        let mid = sorted.count / 2
        if sorted.count % 2 == 0 {
            return (sorted[mid - 1] + sorted[mid]) / 2
        }
        return sorted[mid]
    }
}
