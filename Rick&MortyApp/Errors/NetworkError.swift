//
//  NetworkError.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError
    case invalidResponse
    case serverError(status: Int)
    case decodingError(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid response."
        case .networkError:
            return "A network error occurred."
        case .serverError(let status):
            return "Server error with status code \(status)."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        }
    }
}
