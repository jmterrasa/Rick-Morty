//
//  CachedIMageView.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import SwiftUI
import ImageLoaderKit

struct CachedImageView<Content: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image
    private let content: (Image) -> Content

    init(
        url: URL,
        cache: ImageCacheType = ImageCache.shared,
        placeholder: Image = Image(systemName: "photo"),
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: cache))
        self.placeholder = placeholder
        self.content = content
    }

    var body: some View {
        Group {
            if let image = loader.image {
                content(Image(uiImage: image))
            } else {
                placeholder
            }
        }
        .onAppear(perform: loader.load)
    }
}
