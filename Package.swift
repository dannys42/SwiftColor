// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Color",
    platforms: [ .iOS(.v15), .macOS(.v11), .tvOS(.v12), .watchOS(.v4), .visionOS(.v1), .macCatalyst(.v13) ],
    products: [
        .executable(name: "color-convert", targets: [ "color-convert" ]),
        .library(name: "ColorSpaces", targets: [ "ColorSpaces" ]),
        .library(name: "ColorSpaces-AppKit-UIKit", targets: [ "ColorSpaces-AppKit-UIKit" ]),
        .library(name: "ColorSpaces-SwiftUI", targets: [ "ColorSpaces-SwiftUI" ]),
        .library(name: "TextReadability", targets: [ "TextReadability" ]),
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
            name: "ColorSpaces-AppKit-UIKit",
            dependencies: [
                "ColorSpaces",
            ]),
        .target(
            name: "ColorSpaces-SwiftUI",
            dependencies: [
                "ColorSpaces",
                "ColorSpaces-AppKit-UIKit",
            ]),
        .target(
            name: "TextReadability",
            dependencies: [
                "ColorSpaces",
            ]),
    ]
)
