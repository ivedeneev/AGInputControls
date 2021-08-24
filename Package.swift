// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "AGInputControls",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "AGInputControls",
            targets: ["AGInputControls"]),
    ],

    targets: [
        .target(
            name: "AGInputControls",
            path: "AGInputControls")
    ]
)
