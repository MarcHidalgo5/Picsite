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
    ],
    targets: [
        .target(
            name: "PicsiteKit",
            dependencies: []),
        .testTarget(
            name: "PicsiteKitTests",
            dependencies: ["PicsiteKit"]),
    ]
)
