// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PicsiteUI",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "PicsiteUI",
            targets: ["PicsiteUI"]
        ),
    ],
    dependencies: [
        .package(path: "PicsiteKit"),
        .package(url: "https://github.com/JonasGessner/JGProgressHUD.git", from: "2.1.0"),
        .package(url: "https://github.com/theleftbit/BSWFoundation.git", from: "5.0.0"),
        .package(url: "https://github.com/theleftbit/BSWInterfaceKit.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "PicsiteUI",
            dependencies: ["BSWFoundation",
                          "BSWInterfaceKit", "PicsiteKit",
                          "JGProgressHUD"]
        ),
    ]
)
