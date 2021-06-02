// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SniprSwarmCore",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v12)

    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SniprSwarmCore",
            targets: ["SniprSwarmCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/soto-project/soto.git", from: "5.4.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SniprSwarmCore",
            dependencies: [
                .product(name: "SotoEventBridge", package: "soto"),
                .product(name: "SotoLambda", package: "soto"),
                //.product(name: "SotoCloudWatch", package: "soto"),
                //.product(name: "SotoCloudWatchLogs", package: "soto"),
            ]),
        .testTarget(
            name: "SniprSwarmCoreTests",
            dependencies: ["SniprSwarmCore"]),
    ]
)
