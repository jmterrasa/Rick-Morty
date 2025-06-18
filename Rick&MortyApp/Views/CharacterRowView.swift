//
//  CharacterRowView.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.

import SwiftUI
import SwiftData

struct CharacterRowView: View {
    @StateObject var viewModel: CharacterRowViewModel
    let namespace: Namespace.ID
    var onTap: () -> Void
    var onFavorite: ((Character) -> Void)? = nil
    var showFavoriteButton: Bool = true
    @State private var isPressed = false
    @Query private var favorites: [FavoriteCharacter]
    @State private var showToast = false
    @State private var toastMessage = ""
    @Environment(\.favoritesManager) private var favoritesManager
    
    var isFavorite: Bool {
        favorites.contains { $0.id == viewModel.character.id }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            rowContent
                .background(Color.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                .scaleEffect(isPressed ? 0.97 : 1.0)
                .animation(.easeOut(duration: 0.15), value: isPressed)
                .onTapGesture {
                    isPressed = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                        isPressed = false
                        onTap()
                    }
                }
            
            if showToast {
                Text(toastMessage)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 8)
                    .zIndex(1)
            }
        }
        .contentShape(Rectangle())
        .frame(height: 170)
    }
    
    private var rowContent: some View {
        HStack(alignment: .center, spacing: 20) {
            characterImage
                .frame(width: 130, height: 130)
                .padding(.leading, 8)
            
            characterDetails
                .padding(.leading, 8)
            
            Spacer(minLength: 0)
            
            if showFavoriteButton {
                favoriteButton
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    private var characterImage: some View {
        CachedImageView(url: URL(string: viewModel.character.image)!) { image in
            AnyView(
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 135, height: 135)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            )
        }
        .padding(.leading)
    }
    
    private var characterDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.character.name)
                .font(.title3.bold())
                .fontDesign(.rounded)
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
            
            HStack(spacing: 6) {
                Circle()
                    .fill(viewModel.character.status.color)
                    .frame(width: 10, height: 10)
                Text("\(viewModel.character.status.localized) - \(viewModel.character.species.localized)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
            }
            
            Text(L10n.lastKnownLocation)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(viewModel.character.location.localizedName)
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
            
            Text(L10n.firstSeenIn)
                .font(.caption)
                .foregroundColor(.gray)
            
            if let episodeName = viewModel.character.firstEpisodeName {
                Text(episodeName)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(0.7)
            }
        }
    }
    
    private var favoriteButton: some View {
        VStack {
            Button {
                handleFavoriteToggle()
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .white)
                    .padding(6)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
    }
    
    private func handleFavoriteToggle() {
        let c = viewModel.character
        
        let didAdd = favoritesManager.toggle(character: c, imageData: viewModel.imageData)
        toastMessage = didAdd ? L10n.addedToFavorites : L10n.removedFromFavorites
        showTemporaryToast()
    }
    
    private func showTemporaryToast() {
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
}
