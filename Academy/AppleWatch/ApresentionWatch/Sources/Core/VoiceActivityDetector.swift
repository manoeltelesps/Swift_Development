import Foundation

/// Frame-level speech/silence classification: energy above the noise floor, debounced
/// with ~200ms hysteresis so single stray frames don't flip the state back and forth.
public enum VoiceActivityDetector {
    private static let hysteresisMs: Double = 200

    public static func detect(envelope: Envelope, config: DetectorConfig) -> [Bool] {
        let raw = envelope.dbValues.map { $0 > envelope.noiseFloorDB }
        guard !raw.isEmpty else { return [] }

        let hysteresisFrames = max(1, Int(hysteresisMs / config.frameMs))
        var result = [Bool](repeating: false, count: raw.count)
        var state = raw[0]
        var consecutiveDisagreements = 0

        for i in 0..<raw.count {
            if raw[i] == state {
                consecutiveDisagreements = 0
            } else {
                consecutiveDisagreements += 1
                if consecutiveDisagreements >= hysteresisFrames {
                    state = raw[i]
                    consecutiveDisagreements = 0
                }
            }
            result[i] = state
        }
        return result
    }
}
