// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "STCEngine",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "STCCommon", targets: ["STCEngine"]),
        .library(name: "STCComponents", targets: ["STCEngine"]),
        .library(name: "STCUserInput", targets: ["STCUserInput"]),
        .library(name: "STCSystems", targets: ["STCSystems"]),
        .library(name: "STCEngine", targets: ["STCEngine"]),
        .library(name: "STCObjects", targets: ["STCObjects"]),
        .library(name: "STCLevel", targets: ["STCLevel"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "STCCommon"),
        .target(name: "STCComponents", dependencies: ["STCCommon"]),
        .target(name: "STCSystems", dependencies: ["STCCommon", "STCComponents", "STCObjects"]),
        .target(name: "STCLevel", dependencies: ["STCCommon", "STCComponents", "STCObjects"]),
        .target(name: "STCUserInput"),
        .target(name: "STCEngine", dependencies: ["STCCommon", "STCComponents"]),
        .target(name: "STCObjects", dependencies: ["STCCommon", "STCComponents"]),
    ]
)
