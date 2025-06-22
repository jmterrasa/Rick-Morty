//  CharactersGridViewModel.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.

import Foundation

@MainActor
class CharactersGridViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private var currentPage = 1
    var hasMorePages = true
    private let service: CharacterFetchable
    var debounceTask: Task<Void, Never>?
    
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(service: CharacterFetchable = CharacterFetcher()) {
        self.service = service
    }
    
    func loadCharacters(resetAll: Bool = false) async {
        guard !isLoading, hasMorePages else { return }

        if resetAll {
            characters = []
            currentPage = 1
            hasMorePages = true
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchCharacters(page: currentPage, name: nil)
            if let newCharacters = response.results {
                let existingIds = Set(characters.map(\.id))
                let filtered = newCharacters.filter { !existingIds.contains($0.id) }
                characters.append(contentsOf: filtered)
            }
            currentPage += 1
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = (error as? NetworkError)?.localizedDescription ?? error.localizedDescription
            print("loadCharacters error: \(error)")
        }

        isLoading = false
    }
    
    func performSearch() async {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        hasMorePages = false
        
        do {
            let name = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let response = try await service.fetchCharacters(page: 1, name: name)
            characters = response.results ?? []
            currentPage = 2
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = error.localizedDescription
            characters = []
            print("performSearch error: \(error)")
        }
        
        isLoading = false
    }
    
    func loadMoreSearchResults() async {
        guard !isLoading, hasMorePages else { return }

        isLoading = true
        errorMessage = nil

        do {
            let name = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let queryName = name.isEmpty ? nil : name
            let response = try await service.fetchCharacters(page: currentPage, name: queryName)

            if let newCharacters = response.results {
                let existingIds = Set(characters.map(\.id))
                let filtered = newCharacters.filter { !existingIds.contains($0.id) }
                characters.append(contentsOf: filtered)
            }

            currentPage += 1
            hasMorePages = response.info.next != nil
        } catch {
            errorMessage = error.localizedDescription
            print("loadMoreSearchResults error: \(error)")
        }

        isLoading = false
    }
    
    func scheduleSearchDebounce() {
        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            if isSearching {
                await performSearch()
            }
        }
    }
    
    func reset() {
        characters = []
        currentPage = 1
        hasMorePages = true
    }
}
