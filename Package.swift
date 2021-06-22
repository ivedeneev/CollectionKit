// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "IVCollectionKit",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "IVCollectionKit",
            targets: ["IVCollectionKit"]),
    ],

    targets: [
        .target(
            name: "IVCollectionKit",
            path: "IVCollectionKit")
    ]
)
