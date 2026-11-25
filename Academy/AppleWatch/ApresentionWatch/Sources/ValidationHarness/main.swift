import Core
import Foundation

struct GroundTruthEntry: Decodable {
    let file: String
    let syllables: Int
}

let fixturesDir = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "Fixtures"

let groundTruthPath = (fixturesDir as NSString).appendingPathComponent("groundtruth.json")

guard let groundTruthData = FileManager.default.contents(atPath: groundTruthPath) else {
    FileHandle.standardError.write("Could not read \(groundTruthPath)\n".data(using: .utf8)!)
    exit(1)
}

let entries: [GroundTruthEntry]
do {
    entries = try JSONDecoder().decode([GroundTruthEntry].self, from: groundTruthData)
} catch {
    FileHandle.standardError.write("Could not parse \(groundTruthPath): \(error)\n".data(using: .utf8)!)
    exit(1)
}

guard !entries.isEmpty else {
    FileHandle.standardError.write("No entries in \(groundTruthPath)\n".data(using: .utf8)!)
    exit(1)
}

struct Row {
    let file: String
    let detected: Int
    let expected: Int
    let errorPct: Double
}

var rows: [Row] = []

for entry in entries {
    let wavPath = (fixturesDir as NSString).appendingPathComponent(entry.file)
    do {
        let samples = try WavLoader.loadMono16k(path: wavPath)
        let result = SpeechRateDetector.detect(samples: samples, sampleRate: WavLoader.targetSampleRate)
        let detected = result.syllableCount
        let errorPct = entry.syllables > 0
            ? abs(Double(detected - entry.syllables)) / Double(entry.syllables) * 100
            : (detected == 0 ? 0 : 100)
        rows.append(Row(file: entry.file, detected: detected, expected: entry.syllables, errorPct: errorPct))
    } catch {
        FileHandle.standardError.write("Skipping \(entry.file): \(error)\n".data(using: .utf8)!)
    }
}

guard !rows.isEmpty else {
    FileHandle.standardError.write("No fixtures could be processed.\n".data(using: .utf8)!)
    exit(1)
}

let fileWidth = max(4, rows.map { $0.file.count }.max() ?? 4)

func pad(_ s: String, _ width: Int) -> String { s + String(repeating: " ", count: max(0, width - s.count)) }
func padLeft(_ s: String, _ width: Int) -> String { String(repeating: " ", count: max(0, width - s.count)) + s }

print(pad("file", fileWidth) + "  " + padLeft("detected", 8) + "  " + padLeft("expected", 8) + "  " + padLeft("error%", 8))
print(String(repeating: "-", count: fileWidth + 2 + 8 + 2 + 8 + 2 + 8))

for row in rows {
    print(
        pad(row.file, fileWidth) + "  " +
        padLeft("\(row.detected)", 8) + "  " +
        padLeft("\(row.expected)", 8) + "  " +
        padLeft(String(format: "%.1f", row.errorPct), 8)
    )
}

let meanAbsoluteErrorPct = rows.map { $0.errorPct }.reduce(0, +) / Double(rows.count)
print(String(repeating: "-", count: fileWidth + 2 + 8 + 2 + 8 + 2 + 8))
print("Mean absolute error: \(String(format: "%.1f", meanAbsoluteErrorPct))%  (\(rows.count) file(s))")
