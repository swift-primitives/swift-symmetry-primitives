// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-symmetry-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Symmetry Primitives",
            targets: ["Symmetry Primitives"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-algebra-linear-primitives"),
        .package(path: "../swift-affine-primitives"),
        .package(path: "../swift-dimension-primitives"),
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
        .package(path: "../swift-test-support-primitives"),
    ],
    targets: [
        .target(
            name: "Symmetry Primitives",
            dependencies: [
                .product(name: "Algebra Linear Primitives", package: "swift-algebra-linear-primitives"),
                .product(name: "Affine Primitives", package: "swift-affine-primitives"),
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
                .product(name: "RealModule", package: "swift-numerics"),
            ]
        ),
        .testTarget(
            name: "Symmetry Primitives Tests",
            dependencies: [
                "Symmetry Primitives",
                .product(name: "RealModule", package: "swift-numerics"),
                .product(name: "Test Support Primitives", package: "swift-test-support-primitives"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
