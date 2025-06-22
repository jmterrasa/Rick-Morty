//
//  CachedIMageView.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject var viewModel: CharacterDetailViewModel
    @State private var visibleRows: [Bool] = Array(repeating: false, count: 5)
    @State private var showName = false
    @State private var showImage = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .gray.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .opacity(viewModel.showDetails ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: viewModel.showDetails)

            ScrollView {
                VStack(spacing: 24) {
                    characterImageView()

                    if viewModel.showDetails {
                        VStack(spacing: 20) {
                            Text(viewModel.character.name)
                                .font(.largeTitle.bold())
                                .fontDesign(.rounded)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 4)

                            characterInfoPanel()
                        }
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding()
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .animation(.spring(response: 0.45, dampingFraction: 0.75), value: viewModel.character.id)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                withAnimation(.easeOut(duration: 0.5)) { showImage = true }
                try? await Task.sleep(nanoseconds: 50_000_000)
                withAnimation(.easeOut(duration: 0.4)) { showName = true }
                try? await Task.sleep(nanoseconds: 100_000_000)
                withAnimation(.easeOut(duration: 0.4)) { viewModel.startPresentationAnimation() }

                for i in 0..<visibleRows.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45 + Double(i) * 0.07) {
                        withAnimation {
                            visibleRows[i] = true
                        }
                    }
                }
            }
        }
        .onDisappear {
            viewModel.showDetails = false
        }
    }

    @ViewBuilder
    private func characterImageView() -> some View {
        CachedImageView(url: URL(string: viewModel.character.image)!) { image in
            let styledImage = image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 320, maxHeight: 280)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                .matchedGeometryEffect(id: viewModel.character.id, in: viewModel.namespace)
                .opacity(showImage ? 1 : 0)
                .scaleEffect(showImage ? 1 : 0.9)
                .animation(.easeOut(duration: 0.5), value: showImage)

            return AnyView(styledImage)
        }
    }

    @ViewBuilder
    private func characterInfoPanel() -> some View {
        VStack(spacing: 14) {
            labeledRow(
                title: L10n.status,
                value: viewModel.character.status.localized,
                color: viewModel.character.status.color,
                isVisible: visibleRows[0]
            )

            let species = Species(rawValue: viewModel.character.species.rawValue) ?? .unknown
            labeledRow(
                title: L10n.species,
                value: species.localized,
                isVisible: visibleRows[1]
            )

            labeledRow(
                title: L10n.gender,
                value: viewModel.character.gender.localized,
                isVisible: visibleRows[2]
            )

            labeledRow(
                title: L10n.origin,
                value: viewModel.character.origin.localizedName,
                isVisible: visibleRows[3]
            )

            labeledRow(
                title: L10n.location,
                value: viewModel.character.location.localizedName,
                isVisible: visibleRows[4]
            )
        }
        .padding()
        .frame(maxWidth: 500)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
        )
        .shadow(radius: 10)
    }

    private func labeledRow(title: String, value: String, color: Color? = nil, isVisible: Bool) -> some View {
        HStack(alignment: .center, spacing: 12) {
            if let color = color {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title.uppercased())
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body)
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 8)
        .animation(.easeOut(duration: 0.2), value: isVisible)
    }
}
