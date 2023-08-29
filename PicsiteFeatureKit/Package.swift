// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PicsiteFeatureKit",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "PicsiteAuthKit",
            targets: ["PicsiteAuthKit"]),
        .library(
            name: "PicsiteMapKit",
            targets: ["PicsiteMapKit"]),
        .library(
            name: "PicisteProfileKit",
            targets: ["PicisteProfileKit"]),
        .library(
            name: "PicsiteUploadContentKit",
            targets: ["PicsiteUploadContentKit"]),
        .library(
            name: "PicsiteUserProfileKit",
            targets: ["PicsiteUserProfileKit"]),
    ],
    dependencies: [
        .package(path: "PicsiteKit"),
        .package(path: "PicsiteUI"),
        .package(url: "https://github.com/theleftbit/BSWFoundation.git", from: "5.0.0"),
        .package(url: "https://github.com/theleftbit/BSWInterfaceKit.git", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "PicsiteAuthKit",
            dependencies: ["BSWFoundation", "BSWInterfaceKit", "PicsiteKit", "PicsiteUI"]
        ),
        .target(
            name: "PicsiteMapKit",
            dependencies: ["BSWFoundation", "BSWInterfaceKit", "PicsiteKit", "PicsiteUI", "PicsiteUploadContentKit"]
        ),
        .target(
            name: "PicisteProfileKit",
            dependencies: ["BSWFoundation", "BSWInterfaceKit", "PicsiteKit", "PicsiteUI"]
        ),
        .target(
            name: "PicsiteUploadContentKit",
            dependencies: ["BSWFoundation", "BSWInterfaceKit", "PicsiteKit", "PicsiteUI"]
        ),
        .target(
            name: "PicsiteUserProfileKit",
            dependencies: ["BSWFoundation", "BSWInterfaceKit", "PicsiteKit", "PicsiteUI"]
        ),
    ]
)
