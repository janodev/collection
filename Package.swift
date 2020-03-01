// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "collection",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Collection", type: .static, targets: ["Collection"])
    ],
    dependencies: [
        .package(url: "git@github.com:j4n0/autolayout.git", from: "1.0.0"),
        .package(url: "git@github.com:j4n0/log.git", from: "1.0.0"),
        .package(url: "git@github.com:apple/swift-log.git", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "Collection",
            dependencies: ["AutoLayout", "Log", "Logging"],
            path: "sources"
        ),
        .testTarget(
            name: "CollectionTests",
            dependencies: ["Collection"],
            path: "tests"
        )
    ]
)
