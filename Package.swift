// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HierNav",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "HierNav",
            targets: ["HierNav"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "HierNav",
            dependencies: [
            ]),
        .testTarget(
            name: "HierNavTests",
            dependencies: ["HierNav"]
        ),
    ]
)
