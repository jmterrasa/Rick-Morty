//
//  MainTabView.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CharactersRootView()
                .tabItem {
                    Label(L10n.charactersTitle, systemImage: "person.3.fill")
                }
            
            FavoritesView()
                .tabItem {
                    Label(L10n.favoritesTitle, systemImage: "star.fill")
                }
        }
    }
}

