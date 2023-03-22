// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Detail",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Detail",
            targets: ["Detail"]),
            .library(
                name: "DetailRequirement",
                targets: ["DetailRequirement"]),
    ],
    dependencies: [
        .package(path: "../Platform"),
        .package(path: "../ThirdPartys"),
        .package(path: "../DesignSystem"),
        .package(path: "../Networking")
    ],
    targets: [
        
        .target(
            name: "Detail",
            dependencies: [
                "DetailRequirement",
                .product(name: "ModuleComponents", package: "Platform"),
                .product(name: "ThirdPartys", package: "ThirdPartys"),
                .product(name: "Utils", package: "Platform"),
                .product(name: "Components", package: "DesignSystem"),
                .product(name: "DomainEntity", package: "Networking"),
            ]),
        
            .target(
                name: "DetailRequirement",
                dependencies: [
                    .product(name: "ModuleComponents", package: "Platform"),
                    .product(name: "DomainEntity", package: "Networking"),
                ]),
    ]
)
