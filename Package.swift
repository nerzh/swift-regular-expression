// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "swift-regular-expression",
    products: [
        .library(
            name: "swift-regular-expression",
            targets: ["swift-regular-expression"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "swift-regular-expression",
            dependencies: [])
    ]
)
