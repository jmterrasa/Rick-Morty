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
    @Published var isClosing: Bool = false
    @Published var showDetails = false
    
    let character: Character
    let namespace: Namespace.ID
    
    init(character: Character,
         namespace: Namespace.ID) {
        self.character = character
        self.namespace = namespace
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
