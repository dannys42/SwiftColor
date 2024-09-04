// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Color",
    platforms: [ .iOS(.v15), .macOS(.v11), .tvOS(.v12), .watchOS(.v4), .visionOS(.v1), .macCatalyst(.v13) ],
    products: [
        .executable(name: "color-convert", targets: [ "color-convert" ]),
        .library(name: "ColorSpaces", targets: [ "ColorSpaces" ]),
        .library(name: "ColorSpaces-UIKit", targets: [ "ColorSpaces-UIKit" ]),
        .library(name: "ColorSpaces-SwiftUI", targets: [ "ColorSpaces-SwiftUI" ]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "color-convert",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "ColorSpaces",
            dependencies: [
            ]),
        .target(
            name: "ColorSpaces-UIKit",
            dependencies: [
                "ColorSpaces",
            ]),
        .target(
            name: "ColorSpaces-SwiftUI",
            dependencies: [
                "ColorSpaces",
                "ColorSpaces-UIKit",
            ]),
    ]
)
