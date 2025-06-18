//
//  Rick_MortyAppApp.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import SwiftUI
import SwiftData

@main
struct Rick_MortyAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([FavoriteCharacter.self])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error initiating SwiftData: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.favoritesManager, FavoritesManager(context: sharedModelContainer.mainContext))
        }
        .modelContainer(sharedModelContainer)
    }
}
