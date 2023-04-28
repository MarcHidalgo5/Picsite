// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PicsiteFeatureKit",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "PicsiteAuthKit",
            targets: ["PicsiteAuthKit"]),
        .library(
            name: "PicsiteMapKit",
            targets: ["PicsiteMapKit"]),
    ],
    dependencies: [
        .package(path: "PicsiteKit"),
        .package(path: "PicsiteUI"),
        .package(url: "https://github.com/theleftbit/BSWFoundation.git", from: "5.0.0"),
        .package(url: "https://github.com/theleftbit/BSWInterfaceKit.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "PicsiteAuthKit",
            dependencies: ["BSWFoundation", "BSWInterfaceKit", "PicsiteKit", "PicsiteUI"]
        ),
        .target(
            name: "PicsiteMapKit",
            dependencies: ["BSWFoundation", "BSWInterfaceKit", "PicsiteKit", "PicsiteUI"]
        ),
    ]
)
