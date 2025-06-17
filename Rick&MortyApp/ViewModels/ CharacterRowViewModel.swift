//
//  Untitled.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import Foundation
import SwiftUI

@MainActor
final class CharacterRowViewModel: ObservableObject {
    let character: Character
    @Published var firstEpisodeName: String?
    @Published var isPressed = false
    @Published var imageData: Data?
    private let service: CharacterFetchable
    
    init(character: Character, imageData: Data? = nil, service: CharacterFetchable = CharacterFetcher()) {
        self.character = character
        self.imageData = imageData
        self.service = service
    }

    func loadFirstEpisodeName() async {
        guard let url = character.episode.first else { return }

        do {
            firstEpisodeName = try await service.fetchFirstEpisodeName(from: url)
        } catch {
            print("Error loading episode: \(error)")
        }
    }

}
