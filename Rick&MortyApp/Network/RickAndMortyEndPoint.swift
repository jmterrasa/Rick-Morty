//
//  RickAndMortyEndPoint.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import Foundation

enum RickAndMortyEndpoint {
    case characters(page: Int, name: String? = nil)
    case characterDetail(id: Int)

    func urlComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"

        switch self {
        case .characters(let page, let name):
            
            components.path = "/api/character"
            
            var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
           
            if let name, !name.isEmpty {
                queryItems.append(URLQueryItem(name: "name", value: name))
            }
            components.queryItems = queryItems

        case .characterDetail(let id):
            components.path = "/api/character/\(id)"
        }

        return components
    }
}
