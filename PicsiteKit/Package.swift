// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PicsiteKit",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "PicsiteKit",
            targets: ["PicsiteKit"]),
    ],
    dependencies: [
        .package(name: "Deferred",url: "https://github.com/theleftbit/Deferred.git", from: "4.2.1"),
        .package(name: "BSWFoundation", url: "https://github.com/theleftbit/BSWFoundation.git", from: "5.0.0"),
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.2"),
    ],
    targets: [
        .target(
            name: "PicsiteKit",
            dependencies: ["BSWFoundation"],
            path: "Sources"
        ),
        .testTarget(
            name: "PicsiteKitTests",
            dependencies: ["PicsiteKit", "SnapshotTesting"],
            path: "Tests",
            exclude: ["__Snapshots__"]
        ),
    ]
)
