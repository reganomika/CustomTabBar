// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CustomTabBar",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "CustomTabBar",
            targets: ["CustomTabBar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "CustomTabBar",
            dependencies: ["SnapKit"],
            path: "Sources"),
    ]
)
