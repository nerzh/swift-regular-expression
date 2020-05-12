// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SwiftRegularExpression",
    products: [
        .library(
            name: "SwiftRegularExpression",
            targets: ["SwiftRegularExpression"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftRegularExpression",
            dependencies: [])
    ]
)
