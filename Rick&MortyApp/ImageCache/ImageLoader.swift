//
//  ImageLoader.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import Foundation
import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let url: URL
    private var cache: ImageCacheType?
    private var task: Task<Void, Never>?

    init(url: URL, cache: ImageCacheType? = nil) {
        self.url = url
        self.cache = cache
    }

    deinit {
        task?.cancel()
    }

    func load() {
        if let cached = cache?[url] {
            image = cached
            return
        }

        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.image = uiImage
                        self.cache?[url] = uiImage
                    }
                }
            } catch {
             
            }
        }
    }
}
