// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "LicenseChain",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "LicenseChain",
            targets: ["LicenseChain"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "LicenseChain",
            dependencies: [
                "Alamofire",
                "SwiftyJSON"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "LicenseChainTests",
            dependencies: ["LicenseChain"],
            path: "Tests"
        ),
    ]
)
