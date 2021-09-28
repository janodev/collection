// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "collection",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "CollectionDynamic", type: .dynamic, targets: ["Collection"]),
        .library(name: "CollectionStatic", type: .static, targets: ["Collection"])
    ],
    dependencies: [
        .package(name: "autolayout", url: "git@github.com:janodev/autolayout.git", from: "1.0.0"),
        .package(name: "log", url: "git@github.com:janodev/log.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Collection",
            dependencies: [
              .product(name: "LogDynamic", package: "log"),
              .product(name: "AutoLayoutDynamic", package: "autolayout")
            ],
            path: "sources/main"
        ),
        .testTarget(
            name: "CollectionTests",
            dependencies: [
              "Collection"
            ],
            path: "sources/tests"
        )
    ]
)
