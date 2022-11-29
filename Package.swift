// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "advent-of-code",
	platforms: [
		.macOS(.v13)
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
		.package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-atomics.git", from: "1.0.2")
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.executableTarget(
			name: "AdventOfCode",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Algorithms", package: "swift-algorithms"),
				.product(name: "Atomics", package: "swift-atomics"),
			]),
	]
)
