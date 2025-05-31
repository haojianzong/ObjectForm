// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "ObjectForm",
    platforms: [.iOS(.v16)],
    products: [.library(name: "ObjectForm", targets: ["ObjectForm"])],
    targets: [.target(name: "ObjectForm")]
)
