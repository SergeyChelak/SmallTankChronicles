// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "STCEngine",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "STCCommon", targets: ["STCEngine"]),
        .library(name: "STCComponents", targets: ["STCEngine"]),
        .library(name: "STCResources", targets: ["STCEngine"]),
        .library(name: "STCSystems", targets: ["STCEngine"]),
        .library(name: "STCEngine", targets: ["STCEngine"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "STCCommon"),
        .target(name: "STCComponents", dependencies: ["STCCommon"]),
        .target(name: "STCSystems", dependencies: ["STCCommon", "STCComponents"]),
        .target(name: "STCResources"),
        .target(name: "STCEngine", dependencies: ["STCCommon", "STCComponents"]),

    ]
)
