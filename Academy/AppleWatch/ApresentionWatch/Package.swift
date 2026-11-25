// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SpeechPace",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .executable(name: "ValidationHarness", targets: ["ValidationHarness"])
    ],
    targets: [
        .target(name: "Core"),
        .executableTarget(name: "ValidationHarness", dependencies: ["Core"]),
        .testTarget(name: "CoreTests", dependencies: ["Core"])
    ]
)
