//
//  Untitled.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 18/6/25.
//

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ImageLoaderKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ImageLoaderKit",
            targets: ["ImageLoaderKit"]
        ),
    ],
    targets: [
        .target(
            name: "ImageLoaderKit",
            dependencies: []
        )
    ]
)
