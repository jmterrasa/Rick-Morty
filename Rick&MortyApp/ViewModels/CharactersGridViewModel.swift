//  CharactersGridViewModel.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.

import SwiftUI
import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case loaded([Character])
    case error(String)
}

enum ViewEvent {
    case reset
    case startLoading
    case loadSuccess([Character], hasMorePages: Bool)
    case loadFailure(String)
    case search(String)
    case loadMore
}

@MainActor
class CharactersGridViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .idle
    @Published var searchText: String = ""
    
    private var currentPage = 1
    var hasMorePages = true
    private let service: CharacterFetchable
    var allCharacters: [Character] = []
    private var debounceTask: Task<Void, Never>?
    
    var characters: [Character] { allCharacters }
    var isLoading: Bool { state == .loading }
    var isSearching: Bool { !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    init(service: CharacterFetchable = CharacterFetcher()) {
        self.service = service
    }
    
    private func reduce(event: ViewEvent) async {
        switch (state, event) {
        case (_, .reset):
            currentPage = 1
            hasMorePages = true
            allCharacters = []
            state = .idle
            
        case (.idle, .startLoading),
             (.loaded, .startLoading),
             (.error, .startLoading):
            state = .loading
            
        case (.loading, .loadSuccess(let characters, let hasMore)):
            allCharacters.append(contentsOf: characters)
            currentPage += 1
            hasMorePages = hasMore
            state = .loaded(allCharacters)
            
        case (.loading, .loadFailure(let message)):
            state = .error(message)
            
        case (.idle, .search(let text)),
             (.loaded, .search(let text)),
             (.error, .search(let text)):
            currentPage = 1
            hasMorePages = true
            allCharacters = []
            state = .loading
            await performSearch(text: text)
            
        case (.loaded, .loadMore),
             (.idle, .loadMore),
             (.error, .loadMore):
            guard !isLoading, hasMorePages else { return }
            await loadMore()
            
        default:
            break
        }
    }
    
    func loadCharacters(resetAll: Bool = false) async {
        if resetAll {
            await reduce(event: .reset)
        }
        await reduce(event: .startLoading)
        do {
            let response = try await service.fetchCharacters(page: currentPage, name: nil)
            let newCharacters = response.results ?? []
            let hasMore = response.info.next != nil
            await reduce(event: .loadSuccess(newCharacters, hasMorePages: hasMore))
            currentPage = 2
        } catch let error as NetworkError {
            await reduce(event: .loadFailure(error.localizedDescription))
        } catch {
            await reduce(event: .loadFailure("Unknown error occurred"))
        }
    }
    
    private func performSearch(text: String) async {
        guard !text.isEmpty else {
            await loadCharacters(resetAll: true)
            return
        }
        do {
            let response = try await service.fetchCharacters(page: 1, name: text)
            let results = response.results ?? []
            let hasMore = response.info.next != nil
            await reduce(event: .loadSuccess(results, hasMorePages: hasMore))
            currentPage = 2
        } catch let error as NetworkError {
            await reduce(event: .loadFailure(error.localizedDescription))
        } catch {
            await reduce(event: .loadFailure("Unknown error occurred"))
        }
    }
    
    private func loadMore() async {
        guard !isLoading else { return }
        state = .loading
        
        do {
            let name = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let nextPage = currentPage
            currentPage += 1

            let response = try await service.fetchCharacters(page: nextPage, name: isSearching ? name : nil)
            let newCharacters = response.results ?? []
            let hasMore = response.info.next != nil
            await reduce(event: .loadSuccess(newCharacters, hasMorePages: hasMore))
        } catch let error as NetworkError {
            await reduce(event: .loadFailure(error.localizedDescription))
        } catch {
            await reduce(event: .loadFailure("Unknown error occurred"))
        }
    }
    
    func scheduleSearchDebounce() {
        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            guard let self else { return }
            let originalText = self.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            try? await Task.sleep(nanoseconds: 150_000_000)
            
            if originalText != self.searchText.trimmingCharacters(in: .whitespacesAndNewlines) {
                return
            }
            
            if originalText.isEmpty {
                await self.loadCharacters(resetAll: true)
            } else {
                await reduce(event: .search(originalText))
            }
        }
    }
    
    func loadNextPageIfNeeded() async {
        await reduce(event: .loadMore)
    }
    
    func reset(clearSearchText: Bool = false) {
        debounceTask?.cancel()
        Task {
            await reduce(event: .reset)
            if clearSearchText {
                self.searchText = ""
            }
        }
    }
}
