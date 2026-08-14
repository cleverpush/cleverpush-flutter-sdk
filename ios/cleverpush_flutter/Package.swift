// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "cleverpush_flutter",
    platforms: [
        .iOS("11.0")
    ],
    products: [
        .library(name: "cleverpush-flutter", targets: ["cleverpush_flutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/CleverPush/CleverPush-iOS-SDK.git", exact: "1.34.52")
    ],
    targets: [
        .target(
            name: "cleverpush_flutter",
            dependencies: [
                .product(name: "CleverPush", package: "CleverPush-iOS-SDK")
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include/cleverpush_flutter")
            ]
        )
    ]
)
