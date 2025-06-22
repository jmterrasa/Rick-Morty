//
//  FavoritesManagerEnvironment.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 19/6/25.
//
import Foundation
import SwiftUI

private struct EmptyFavoritesManager: FavoritesManaging {
    func isFavorite(id: Int) -> Bool { false }
    func toggle(character: Character, imageData: Data?) -> Bool { false }
    func delete(_ favorite: FavoriteCharacter) {}
}


private struct FavoritesManagerKey: EnvironmentKey {
    static var defaultValue: FavoritesManaging {
        EmptyFavoritesManager()
    }
}

extension EnvironmentValues {
    var favoritesManager: FavoritesManaging {
        get { self[FavoritesManagerKey.self] }
        set { self[FavoritesManagerKey.self] = newValue }
    }
}
