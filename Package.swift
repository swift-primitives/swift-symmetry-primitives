// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-symmetry-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Symmetry Primitives",
            targets: ["Symmetry Primitives"]
        ),
        .library(
            name: "Symmetry Primitives Test Support",
            targets: ["Symmetry Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-linear-primitives"),
        .package(path: "../swift-algebra-primitives"),
        .package(url: "https://github.com/swift-primitives/swift-pair-primitives.git", branch: "main"),
        .package(path: "../swift-affine-primitives"),
        .package(path: "../swift-affine-geometry-primitives"),
        .package(path: "../swift-cardinal-primitives"),
        .package(path: "../swift-dimension-primitives"),
        .package(path: "../swift-finite-primitives"),
        .package(path: "../swift-numeric-primitives"),
        .package(path: "../swift-ordinal-primitives"),
    ],
    targets: [
        .target(
            name: "Symmetry Primitives",
            dependencies: [
                .product(name: "Linear Primitives", package: "swift-linear-primitives"),
                .product(name: "Algebra Group Primitives", package: "swift-algebra-primitives"),
                .product(name: "Pair Primitives", package: "swift-pair-primitives"),
                .product(name: "Affine Primitives", package: "swift-affine-primitives"),
                .product(name: "Affine Geometry Primitives", package: "swift-affine-geometry-primitives"),
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
                .product(name: "Finite Primitives", package: "swift-finite-primitives"),
                .product(name: "Real Primitives", package: "swift-numeric-primitives"),
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
            ]
        ),
        .target(
            name: "Symmetry Primitives Test Support",
            dependencies: [
                "Symmetry Primitives",
                .product(name: "Cardinal Primitives Test Support", package: "swift-cardinal-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Symmetry Primitives Tests",
            dependencies: [
                "Symmetry Primitives",
                "Symmetry Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
