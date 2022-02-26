// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PicsiteUI",
    products: [
        .library(
            name: "PicsiteUI",
            targets: ["PicsiteUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PicsiteUI",
            dependencies: [
            ]),
        .testTarget(
            name: "PicsiteUITests",
            dependencies: ["PicsiteUI"]),
    ]
)
