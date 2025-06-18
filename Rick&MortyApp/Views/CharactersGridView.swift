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
    @State private var debounceTask: Task<Void, Never>? = nil
    
    var body: some View {
        VStack {
            searchBar
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.characters) { character in
                        row(for: character)
                    }
                }
                .padding(.vertical)
            }
            .background(Color.black)
            .preferredColorScheme(.dark)
            .task {
                if viewModel.characters.isEmpty {
                    await viewModel.loadCharacters(resetAll: true)
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
                .onChange(of: viewModel.searchText) { newValue in
                    guard newValue != "" else { return }
                    viewModel.scheduleSearchDebounce()
                    
                    if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        debounceTask?.cancel()
                        debounceTask = Task {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                await viewModel.loadCharacters(resetAll: true)
                            }
                        }
                    }
                }
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.debounceTask?.cancel()
                    viewModel.searchText = ""
                    Task { @MainActor in
                        viewModel.reset()
                        await viewModel.loadCharacters(resetAll: true)
                    }
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
    private func row(for character: Character) -> some View {
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
        .onAppear {
            guard !viewModel.isLoading, viewModel.hasMorePages else { return }
            
            if let index = viewModel.characters.firstIndex(of: character),
               index == viewModel.characters.count - 6 {
                Task { @MainActor in
                    if viewModel.isSearching {
                        await viewModel.loadMoreSearchResults()
                    } else {
                        await viewModel.loadCharacters()
                    }
                }
            }
        }
    }
}
