// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ModuleComponents",
            type: .dynamic,
            targets: ["ModuleComponents"]),
        
            .library(
                name: "ReusableKit",
                type: .static,
                targets: ["ReusableKit"]),
        
            .library(
                name: "Utils",
                type: .static,
                targets: ["Utils"]),
        
            .library(
                name: "Common",
                type: .dynamic,
                targets: ["Common"]),
        
            .library(
                name: "ImageLoader",
                type: .static,
                targets: ["ImageLoader"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(
            name: "ModuleComponents",
            dependencies: []),
        
            .target(
                name: "Utils",
                dependencies: [
                    "RxSwift",
                    .product(name: "RxCocoa", package: "RxSwift"),
                    .product(name: "RxRelay", package: "RxSwift"),
                ]
            ),
        
            .target(
                name: "ReusableKit",
                dependencies: []),
        
            .target(
                name: "Common",
                dependencies: []),
        
            .target(
                name: "ImageLoader",
                dependencies: []),
        
    ]
)
