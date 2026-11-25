import AVFoundation

/// Converts tap buffers from the mic's native format to a target format (16kHz mono
/// throughout this app). Deliberately kept outside main-actor isolation: it's driven
/// from `installTap`'s real-time audio thread, and only the resulting `[Float]`
/// (Sendable) crosses back to whichever actor the caller hops to. Shared by
/// `AudioCaptureService` (sliding-window live rate) and `CalibrationRecorder`
/// (one-shot full capture).
final class AudioFormatConverter {
    private let converter: AVAudioConverter
    private let targetFormat: AVAudioFormat

    init?(inputFormat: AVAudioFormat, targetFormat: AVAudioFormat) {
        guard let converter = AVAudioConverter(from: inputFormat, to: targetFormat) else { return nil }
        self.converter = converter
        self.targetFormat = targetFormat
    }

    func process(_ buffer: AVAudioPCMBuffer) -> [Float] {
        let ratio = targetFormat.sampleRate / buffer.format.sampleRate
        let outCapacity = AVAudioFrameCount(Double(buffer.frameLength) * ratio) + 1024
        guard let outBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: outCapacity) else { return [] }

        var didSupply = false
        var conversionError: NSError?
        converter.convert(to: outBuffer, error: &conversionError) { _, outStatus in
            if didSupply {
                outStatus.pointee = .endOfStream
                return nil
            }
            didSupply = true
            outStatus.pointee = .haveData
            return buffer
        }

        guard conversionError == nil, let channelData = outBuffer.floatChannelData else { return [] }
        return Array(UnsafeBufferPointer(start: channelData[0], count: Int(outBuffer.frameLength)))
    }
}
