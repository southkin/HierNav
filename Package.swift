// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HierNav",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HierNav",
            targets: ["HierNav"]),
    ],
    dependencies: [
        .package(url: "https://github.com/southkin/KinKit", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HierNav",
            dependencies: [
                .product(name: "KinKit", package: "KinKit"),
            ]),
        .testTarget(
            name: "HierNavTests",
            dependencies: ["HierNav"]
        ),
    ]
)
