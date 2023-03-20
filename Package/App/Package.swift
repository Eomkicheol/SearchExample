// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "App",
            targets: ["App"]),
    ],
    dependencies: [
        .package(path: "../Platform"),
        .package(path: "../Root"),
    ],
    targets: [
        
        .target(
            name: "App",
            dependencies: [
                .product(name: "ModuleComponents", package: "Platform"),
                .product(name: "RootRequirement", package: "Root"),
                .product(name: "Root", package: "Root")
            ]),
    ]
)
