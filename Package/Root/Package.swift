// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Root",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Root",
            targets: ["Root"]),
        .library(
            name: "RootRequirement",
            targets: ["RootRequirement"]),
    ],
    dependencies: [
        .package(path: "../Platform"),
        .package(path: "../Launch"),
        .package(path: "../Search"),
        .package(path: "../Networking")
    ],
    targets: [
        
        .target(
            name: "RootRequirement",
            dependencies: [
                .product(name: "ModuleComponents", package: "Platform"),
            ]),
        
            .target(
                name: "Root",
                dependencies: [
                    "RootRequirement",
                    .product(name: "ModuleComponents", package: "Platform"),
                    .product(name: "LaunchRequirement", package: "Launch"),
                    .product(name: "Launch", package: "Launch"),
                    .product(name: "SearchRequirement", package: "Search"),
                    .product(name: "Search", package: "Search"),
                    .product(name: "Networking", package: "Networking"),
                    .product(name: "Utils", package: "Platform"),
                ]),
    ]
)
