//
//  Untitled.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import SwiftUI
import SwiftData

struct CharactersRootView: View {
    @Environment(\.modelContext) private var context
    @Query private var favorites: [FavoriteCharacter]
    
    @StateObject private var viewModel = CharactersViewModel()
    @StateObject private var coordinator = NavigationCoordinator()
    @State private var isClosing = false
    @Namespace private var namespace
    
    var body: some View {
        TabView {
            NavigationStack(path: $coordinator.path) {
                CharacterGridView(
                    viewModel: viewModel,
                    coordinator: coordinator
                    
                )
                .navigationTitle(Text(L10n.charactersTitle))
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case let .characterDetail(character, ns):
                        let detailVM = CharacterDetailViewModel(character: character, namespace: ns)
                        CharacterDetailView(viewModel: detailVM)
                            .onChange(of: detailVM.isClosing) { _, newValue in
                                if newValue {
                                    coordinator.pop()
                                }
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
        .task {
            await viewModel.loadCharacters()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FavoriteCharacter.self, configurations: config)
    
    return CharactersRootView()
        .modelContainer(container)
        .preferredColorScheme(.dark)
}
