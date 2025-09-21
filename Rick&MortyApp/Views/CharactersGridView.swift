//
//  CharactersGridView.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import SwiftUI
import SwiftData

struct CharactersGridView: View {
    @ObservedObject var viewModel: CharactersGridViewModel
    @ObservedObject var coordinator: NavigationCoordinator
    @Environment(\.favoritesManager) private var favoritesManager
    @Query private var favorites: [FavoriteCharacter]
    @Namespace private var namespace

    var body: some View {
        VStack {
            searchBar
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.characters, id: \.id) { character in
                            let characterViewModel = CharacterViewModel(from: character)
                            row(for: characterViewModel)
                                .id(character.id)
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color.black)
                .preferredColorScheme(.dark)
                .onChange(of: viewModel.searchText) { newValue in
                    if newValue.isEmpty {
                        if let firstId = viewModel.characters.first?.id {
                            withAnimation {
                                proxy.scrollTo(firstId, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(L10n.searchPlaceholder, text: $viewModel.searchText)
                .textFieldStyle(.plain)
                .submitLabel(.search)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.scheduleSearchDebounce()
                }
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func row(for character: CharacterViewModel) -> some View {
        let rowViewModel = CharacterRowViewModel(character: character)
        
        CharacterRowView(
            viewModel: rowViewModel,
            namespace: namespace,
            onTap: {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                coordinator.push(.characterDetail(character, namespace))
            },
            showFavoriteButton: true
        )
        .task(id: character.id) {
            guard !viewModel.isLoading,
                  viewModel.hasMorePages,
                  !viewModel.characters.isEmpty else { return }
            
            if let index = viewModel.characters.firstIndex(where: { $0.id == character.id }),
               index >= viewModel.characters.count - 3 {
                await viewModel.loadNextPageIfNeeded()
            }
        }
    }
}
