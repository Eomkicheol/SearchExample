// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Launch",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "LaunchRequirement",
            targets: ["LaunchRequirement"]),
        
            .library(
                name: "Launch",
                targets: ["Launch"]),
    ],
    dependencies: [
        .package(path: "../Platform"),
        .package(path: "../ThirdPartys"),
    ],
    targets: [
        .target(
            name: "LaunchRequirement",
            dependencies: [
                .product(name: "ModuleComponents", package: "Platform"),
            ]),
        
            .target(
                name: "Launch",
                dependencies: [
                    "LaunchRequirement",
                    .product(name: "ModuleComponents", package: "Platform"),
                    .product(name: "ThirdPartys", package: "ThirdPartys"),
                ]),
    ]
)
