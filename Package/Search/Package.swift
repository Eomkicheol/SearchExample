// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Search",
            targets: ["Search"]),
        
            .library(
                name: "SearchRequirement",
                targets: ["SearchRequirement"]),
    ],
    dependencies: [
        .package(path: "../Platform"),
        .package(path: "../ThirdPartys"),
        .package(path: "../Networking"),
        .package(path: "../DesignSystem"),
        .package(path: "../Detail")
    ],
    targets: [
        .target(
            name: "Search",
            dependencies: [
                "SearchRequirement",
                .product(name: "ModuleComponents", package: "Platform"),
                .product(name: "ThirdPartys", package: "ThirdPartys"),
                .product(name: "Utils", package: "Platform"),
                .product(name: "Components", package: "DesignSystem"),
                .product(name: "DetailRequirement", package: "Detail"),
                .product(name: "Detail", package: "Detail"),
                .product(name: "ImageLoader", package: "Platform"),
                .product(name: "DomainEntity", package: "Networking"),
                .product(name: "Apis", package: "Networking"),
                .product(name: "DomainEntity", package: "Networking"),
                
            ]),
        
            .target(
                name: "SearchRequirement",
                dependencies: [
                    .product(name: "ModuleComponents", package: "Platform"),
                ]),
        .testTarget(
            name: "SearchTests",
            dependencies: ["Search"]),
    ]
)
