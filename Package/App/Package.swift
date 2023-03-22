// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "App",
            type: .static,
            targets: ["App"]),
        
            .library(
                name: "AppRequirement",
                type: .dynamic,
                targets: ["AppRequirement"]),
    ],
    dependencies: [
        .package(path: "../Platform"),
        .package(path: "../Detail"),
        .package(path: "../Search"),
        .package(path: "../Networking"),
        .package(path: "../Launch"),
        .package(path: "../Root"),
    ],
    targets: [
        
        .target(
            name: "App",
            dependencies: [
                "AppRequirement",
                .product(name: "ModuleComponents", package: "Platform"),
                                .product(name: "RootRequirement", package: "Root"),
                                .product(name: "Root", package: "Root"),
                                .product(name: "DetailRequirement", package: "Detail"),
                                .product(name: "Detail", package: "Detail"),
                                .product(name: "SearchRequirement", package: "Search"),
                                .product(name: "Search", package: "Search"),
                                .product(name: "LaunchRequirement", package: "Launch"),
                                .product(name: "Launch", package: "Launch")
            ]),
        
            .target(
                name: "AppRequirement",
                dependencies: [
                    .product(name: "ModuleComponents", package: "Platform"),
                                        .product(name: "RootRequirement", package: "Root"),
                                        .product(name: "DetailRequirement", package: "Detail"),
                                        .product(name: "SearchRequirement", package: "Search"),
                                        .product(name: "LaunchRequirement", package: "Launch")
                ]),
    ]
)
