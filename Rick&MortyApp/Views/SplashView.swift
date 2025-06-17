//
//  SplashView.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import SwiftUI
import SwiftData

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            CharactersRootView()
        } else {
            ZStack {
                Image("RickAndMortySplash")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environment(\.modelContext, try! ModelContainer(for: FavoriteCharacter.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)).mainContext)
        .preferredColorScheme(.dark)
}
