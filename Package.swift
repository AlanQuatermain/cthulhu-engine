// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if swift(>=6.2)
let swiftTesting: Package.Dependency = .package(
  url: "https://github.com/swiftlang/swift-testing.git",
  branch: "main"
)
#else
let swiftTesting: Package.Dependency = .package(
  url: "https://github.com/swiftlang/swift-testing.git",
  from: "6.1.0"
)
#endif

let package = Package(
    name: "CthulhuEngine",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CthulhuEngine",
            targets: ["CthulhuEngine"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/alanquatermain/DiceRoller.git", branch: "main"),
        swiftTesting,
        // Enables `swift package generate-documentation` via swift-docc plugin
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CthulhuEngine",
            dependencies: [
                .product(name: "DiceRoller", package: "DiceRoller")
            ]
        ),
        .testTarget(
            name: "CthulhuEngineTests",
            dependencies: [
                "CthulhuEngine",
                .product(name: "Testing", package: "swift-testing")
            ]
        ),
    ]
)
