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
        .package(name: "BSWFoundation", url: "https://github.com/theleftbit/BSWFoundation.git", from: "5.0.0"),
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.2"),
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "PicsiteKit",
            dependencies: [.product(name: "FirebaseAuth", package: "Firebase"),.product(name: "FirebaseFirestore", package: "Firebase"), "BSWFoundation"],
            path: "Sources"
            ),
        .testTarget(
            name: "PicsiteKitTests",
            dependencies: ["PicsiteKit", "SnapshotTesting"],
            path: "Tests"
        ),
    ]
)

