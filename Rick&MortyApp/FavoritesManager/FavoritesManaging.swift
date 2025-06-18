//
//  FavoritesManaging.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 19/6/25.
//
import Foundation
import SwiftData

protocol FavoritesManaging {
    func isFavorite(id: Int) -> Bool
    func toggle(character: Character, imageData: Data?) -> Bool
    func delete(_ favorite: FavoriteCharacter)
}

final class FavoritesManager: FavoritesManaging {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func isFavorite(id: Int) -> Bool {
        let descriptor = FetchDescriptor<FavoriteCharacter>(predicate: #Predicate { $0.id == id })
        return (try? context.fetchCount(descriptor)) ?? 0 > 0
    }

    func toggle(character: Character, imageData: Data?) -> Bool {
        let descriptor = FetchDescriptor<FavoriteCharacter>(predicate: #Predicate { $0.id == character.id })
        if let existing = try? context.fetch(descriptor).first {
            context.delete(existing)
            try? context.save()
            return false
        } else {
            let favorite = FavoriteCharacter(
                id: character.id,
                name: character.name,
                image: character.image,
                imageData: imageData,
                status: character.status.rawValue,
                species: character.species.rawValue,
                gender: character.gender.rawValue,
                originName: character.origin.name,
                locationName: character.location.name,
                firstEpisodeName: character.firstEpisodeName
            )
            context.insert(favorite)
            try? context.save()
            return true
        }
    }

    func delete(_ favorite: FavoriteCharacter) {
        context.delete(favorite)
        try? context.save()
    }
}
