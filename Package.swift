// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScribbleFoundation",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .macCatalyst(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ScribbleFoundation",
            targets: ["ScribbleFoundation"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-atomics.git",
            .upToNextMajor(from: "1.2.0")
        )
    ],
    targets: [
        .target(
            name: "ScribbleFoundation",
            dependencies: []
        ),
        .testTarget(
            name: "ScribbleFoundationTests",
            dependencies: [
                .product(name: "Atomics", package: "swift-atomics")
            ]
        ),
    ]
)
