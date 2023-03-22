// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Components",
            type: .static,
            targets: ["Components"]),
    ],
    dependencies: [
        .package(url: "https://github.com/devxoul/Then.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.0")),
        .package(path: "../Platform"),
        .package(path: "../Networking"),
    ],
    targets: [
        
        .target(
            name: "Components",
            dependencies: [
                "Then",
                "SnapKit",
                .product(name: "Common", package: "Platform"),
                .product(name: "ReusableKit", package: "Platform"),
                .product(name: "ImageLoader", package: "Platform"),
                .product(name: "DomainEntity", package: "Networking"),
            ]),
        
    ]
)
