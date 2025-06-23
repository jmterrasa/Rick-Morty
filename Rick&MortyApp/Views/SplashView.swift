//
//  SplashView.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isReady = false
    @StateObject private var viewModel = CharactersGridViewModel()

    var body: some View {
        Group {
            if isReady {
                CharactersRootView(viewModel: viewModel)
            } else {
                ZStack {
                    Image("RickAndMortySplash")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
                .task {
                    await loadInitialData()
                    withAnimation {
                        isReady = true
                    }
                }
            }
        }
    }

    private func loadInitialData() async {
        await viewModel.loadCharacters(resetAll: true)
    }
}
