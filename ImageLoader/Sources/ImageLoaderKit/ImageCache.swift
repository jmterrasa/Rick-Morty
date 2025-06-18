//
//  ImageCache.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 18/6/25.
//
import UIKit
import Foundation

public final class ImageCache: ImageCacheType, @unchecked Sendable {
    public static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    public init() {}

    public subscript(_ key: URL) -> UIImage? {
        get {
            cache.object(forKey: key as NSURL)
        }
        set {
            if let image = newValue {
                cache.setObject(image, forKey: key as NSURL)
            } else {
                cache.removeObject(forKey: key as NSURL)
            }
        }
    }
}
