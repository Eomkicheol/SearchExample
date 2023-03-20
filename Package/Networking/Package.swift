// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Networking",
            targets: ["Networking"]),
        
            .library(
                name: "Apis",
                targets: ["Apis"]),
        
            .library(
                name: "Entitys",
                targets: ["Entitys"]),
        
            .library(
                name: "DomainEntity",
                targets: ["DomainEntity"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        .package(path: "../Platform")
    ],
    targets: [
        
        .target(
            name: "Networking",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxMoya", package: "Moya"),
            ]),
        
            .target(
                name: "Apis",
                dependencies: [
                    .product(name: "RxMoya", package: "Moya"),
                ]),
        
            .target(
                name: "Entitys",
                dependencies: [
                ]),
        
            .target(
                name: "DomainEntity",
                dependencies: [
                    "Entitys",
                    .product(name: "Common", package: "Platform"),
                ]),
    ]
)
