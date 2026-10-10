// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "LicenseChain",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "LicenseChain",
            targets: ["LicenseChain"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
        .package(url: "https://github.com/airsidemobile/JOSESwift.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "LicenseChain",
            dependencies: [
                "Alamofire",
                "SwiftyJSON",
                "JOSESwift"
            ],
            path: "Sources"
        ),
    ]
)
