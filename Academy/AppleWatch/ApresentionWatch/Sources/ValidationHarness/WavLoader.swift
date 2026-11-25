import AVFoundation
import Foundation

enum WavLoaderError: Error, CustomStringConvertible {
    case cannotOpen(String)
    case cannotConvert(String)

    var description: String {
        switch self {
        case .cannotOpen(let path): return "cannot open \(path)"
        case .cannotConvert(let path): return "cannot convert \(path) to 16kHz mono"
        }
    }
}

enum WavLoader {
    static let targetSampleRate: Double = 16_000

    /// Loads a .wav file and returns mono Float samples at 16 kHz, converting if the
    /// file isn't already in that format (fixtures are expected to be 16kHz mono, but
    /// this keeps the harness tolerant of whatever gets dropped into Fixtures/).
    static func loadMono16k(path: String) throws -> [Float] {
        guard let file = try? AVAudioFile(forReading: URL(fileURLWithPath: path)) else {
            throw WavLoaderError.cannotOpen(path)
        }

        guard let targetFormat = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: targetSampleRate,
            channels: 1,
            interleaved: false
        ) else {
            throw WavLoaderError.cannotConvert(path)
        }

        if file.processingFormat.sampleRate == targetSampleRate,
           file.processingFormat.channelCount == 1 {
            return try readAll(file: file, format: file.processingFormat)
        }

        guard let converter = AVAudioConverter(from: file.processingFormat, to: targetFormat) else {
            throw WavLoaderError.cannotConvert(path)
        }

        guard let sourceBuffer = AVAudioPCMBuffer(
            pcmFormat: file.processingFormat,
            frameCapacity: AVAudioFrameCount(file.length)
        ) else {
            throw WavLoaderError.cannotConvert(path)
        }
        try file.read(into: sourceBuffer)

        let ratio = targetSampleRate / file.processingFormat.sampleRate
        let outCapacity = AVAudioFrameCount(Double(sourceBuffer.frameLength) * ratio) + 1024
        guard let outputBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: outCapacity) else {
            throw WavLoaderError.cannotConvert(path)
        }

        var didSupply = false
        var conversionError: NSError?
        converter.convert(to: outputBuffer, error: &conversionError) { _, outStatus in
            if didSupply {
                outStatus.pointee = .endOfStream
                return nil
            }
            didSupply = true
            outStatus.pointee = .haveData
            return sourceBuffer
        }
        if let conversionError {
            throw WavLoaderError.cannotConvert("\(path): \(conversionError.localizedDescription)")
        }

        return floatSamples(from: outputBuffer)
    }

    private static func readAll(file: AVAudioFile, format: AVAudioFormat) throws -> [Float] {
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length)) else {
            throw WavLoaderError.cannotOpen(file.url.path)
        }
        try file.read(into: buffer)
        return floatSamples(from: buffer)
    }

    private static func floatSamples(from buffer: AVAudioPCMBuffer) -> [Float] {
        guard let channelData = buffer.floatChannelData else { return [] }
        let count = Int(buffer.frameLength)
        return Array(UnsafeBufferPointer(start: channelData[0], count: count))
    }
}
