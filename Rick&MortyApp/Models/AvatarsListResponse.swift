//
//  Untitled.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//
// MARK: - Response

import Foundation

struct CharactersListResponse: Codable, Hashable {
    let info: Info
    var results: [Character]?
}




