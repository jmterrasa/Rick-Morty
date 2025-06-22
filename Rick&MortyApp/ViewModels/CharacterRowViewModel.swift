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
    @Published var isPressed = false
    @Published var imageData: Data?
    
    init(character: Character, imageData: Data? = nil) {
        self.character = character
        self.imageData = imageData
    }
}
