// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "ValuePicker",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "ValuePicker", targets: ["ValuePicker"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ValuePicker",
            dependencies: [],
            path: "Sources")
    ]
)
