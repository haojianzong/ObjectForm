// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ObjectForm",
    platforms: [.iOS(.v13)],
    products: [.library(name: "ObjectForm", targets: ["ObjectForm"])],
    targets: [.target(name: "ObjectForm")]
)
