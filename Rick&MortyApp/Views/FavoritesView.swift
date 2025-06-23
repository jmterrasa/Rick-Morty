//
//  Untitled.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query var favorites: [FavoriteCharacter]
    @Environment(\.favoritesManager) private var favoritesManager
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(favorites, id: \.id) { fav in
                    FavoriteRow(fav: fav, namespace: namespace)
                        .padding(.vertical, 4)
                        .listRowSeparator(.hidden)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        delete(favorites[index])
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(L10n.favoritesTitle)
            .background(Color.black)
            .preferredColorScheme(.dark)
        }
    }
    
    private func delete(_ fav: FavoriteCharacter) {
        favoritesManager.delete(fav)
    }
}

private struct FavoriteRow: View {
    let fav: FavoriteCharacter
    let namespace: Namespace.ID
    
    var body: some View {
        let character = Character(
            id: fav.id,
            name: fav.name,
            status: Status(rawValue: fav.status) ?? .unknown,
            species: Species(rawValue: fav.species) ?? .unknown,
            type: "",
            gender: Gender(rawValue: fav.gender) ?? .unknown,
            origin: .init(name: fav.originName, url: ""),
            location: .init(name: fav.locationName, url: ""),
            image: fav.image,
            episode: [],
            url: "",
            created: "",
            firstEpisodeName: fav.firstEpisodeName
        )
        
        let characterViewModel = CharacterViewModel(from: character)
        let viewModel = CharacterRowViewModel(character: characterViewModel, imageData: fav.imageData)
        
        CharacterRowView(
            viewModel: viewModel,
            namespace: namespace,
            onTap: {},
            showFavoriteButton: false
        )
    }
}
