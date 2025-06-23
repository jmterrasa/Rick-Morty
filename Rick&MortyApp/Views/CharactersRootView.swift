//
//  Untitled.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import SwiftUI
import SwiftData

struct CharactersRootView: View {
    @Query private var favorites: [FavoriteCharacter]
    @StateObject private var coordinator = NavigationCoordinator()
    @State private var isClosing = false
    @Namespace private var namespace
    @ObservedObject var viewModel: CharactersGridViewModel
    
    var body: some View {
        TabView {
            NavigationStack(path: $coordinator.path) {
                CharactersGridView(
                    viewModel: viewModel,
                    coordinator: coordinator
                    
                )
                .navigationTitle(Text(L10n.charactersTitle))
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case let .characterDetail(character, ns):
                        if let originalCharacter = viewModel.allCharacters.first(where: { $0.id == character.id }) {
                            let detailVM = CharacterDetailViewModel(character: originalCharacter, namespace: ns)
                            CharacterDetailView(viewModel: detailVM)
                                .onChange(of: detailVM.isClosing) { _, newValue in
                                    if newValue {
                                        coordinator.pop()
                                    }
                                }
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            .tabItem {
                Label(L10n.charactersTitle, systemImage: "person.3.fill")
            }
            
            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label(L10n.favoritesTitle, systemImage: "star.fill")
            }
        }
    }
}
