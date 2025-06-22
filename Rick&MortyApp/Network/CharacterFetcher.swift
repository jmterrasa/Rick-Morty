//
//  CharacterFetcher.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import Foundation

protocol CharacterFetchable {
    func fetchCharacters(page: Int, name: String?) async throws -> CharactersListResponse
    func fetchEpisodeName(from url: URL) async throws -> String
}

final class CharacterFetcher: CharacterFetchable {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchCharacters(page: Int, name: String? = nil) async throws -> CharactersListResponse {
        let components = RickAndMortyEndpoint.characters(page: page, name: name).urlComponents()
      
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            
            if let apiError = try? JSONDecoder().decode([String: String].self, from: data),
               let message = apiError["error"] {
                print("API Error: \(message)")
            } else {
                print("Error desconocido. Código: \(httpResponse.statusCode)")
            }
            throw NetworkError.serverError(status: httpResponse.statusCode)
        }

        var responseObject = try JSONDecoder().decode(CharactersListResponse.self, from: data)

        if var characters = responseObject.results {
            try await withThrowingTaskGroup(of: (Int, String).self) { group in
                for (index, character) in characters.enumerated() {
                    if let firstEpisodeURL = character.episode.first {
                        group.addTask {
                            let name = try await self.fetchEpisodeName(from: firstEpisodeURL)
                            return (index, name)
                        }
                    }
                }

                for try await (index, episodeName) in group {
                    characters[index].firstEpisodeName = episodeName
                }
            }
            responseObject.results = characters
        }

        return responseObject
    }

    func fetchEpisodeName(from url: URL) async throws -> String {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw NetworkError.serverError(status: code)
        }

        let episode = try JSONDecoder().decode(Episode.self, from: data)
        return episode.name
    }
}
