// swift-tools-version: 6.2

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
        )
    ],
    dependencies: [
        .package(path: "../swift-algebra-linear-primitives"),
        .package(path: "../swift-algebra-group-primitives"),
        .package(path: "../swift-affine-primitives"),
        .package(path: "../swift-dimension-primitives"),
        .package(path: "../swift-numeric-primitives")
    ],
    targets: [
        .target(
            name: "Symmetry Primitives",
            dependencies: [
                .product(name: "Algebra Linear Primitives", package: "swift-algebra-linear-primitives"),
                .product(name: "Algebra Group Primitives", package: "swift-algebra-group-primitives"),
                .product(name: "Affine Primitives", package: "swift-affine-primitives"),
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
                .product(name: "Real Primitives", package: "swift-numeric-primitives")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .strictMemorySafety()
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
