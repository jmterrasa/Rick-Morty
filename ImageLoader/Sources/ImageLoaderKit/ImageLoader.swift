
//
//  Untitled.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 18/6/25.
//

import Foundation
import SwiftUI

@MainActor
public final class ImageLoader: ObservableObject {
    @Published public var image: UIImage?

    private let url: URL
    private var cache: ImageCacheType?
    private var task: Task<Void, Never>?

    public init(url: URL, cache: ImageCacheType? = nil) {
        self.url = url
        self.cache = cache
    }

    deinit {
        task?.cancel()
    }

    public func load() {
        if let cached = cache?[url] {
            image = cached
            return
        }

        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    self.image = uiImage
                    self.cache?[self.url] = uiImage
                }
            } catch {
                print("Failed to load image from URL: \(url.absoluteString) - Error: \(error.localizedDescription)")
            }
        }
    }
}
