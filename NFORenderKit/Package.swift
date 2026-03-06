// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NFORenderKit",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "NFORenderKit", targets: ["NFORenderKit"]),
    ],
    targets: [
        .target(name: "NFORenderKit"),
        .testTarget(
            name: "NFORenderKitTests",
            dependencies: ["NFORenderKit"]
        ),
    ]
)
