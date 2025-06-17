//
//  Untitled.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import Foundation
import SwiftUI

@MainActor
class CharacterDetailViewModel: ObservableObject {
    @Published var firstEpisodeName: String?
    @Published var isClosing: Bool = false
    @Published var showDetails = false

    let character: Character
    let namespace: Namespace.ID

    private let service: CharacterFetchable

    init(character: Character,
         namespace: Namespace.ID,
         service: CharacterFetchable = CharacterFetcher()) {
        self.character = character
        self.namespace = namespace
        self.service = service
    }

    func loadFirstEpisodeName() async {
        guard let url = character.episode.first else { return }
        do {
            firstEpisodeName = try await service.fetchFirstEpisodeName(from: url)
        } catch {
            print("Error loading episode name: \(error)")
        }
    }

    func startPresentationAnimation() {
        withAnimation(.easeOut.delay(0.15)) {
            showDetails = true
        }
    }

    func triggerDismiss() {
        isClosing = true
    }
}
