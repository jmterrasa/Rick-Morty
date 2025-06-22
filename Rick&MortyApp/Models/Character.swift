//
//  Character.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import Foundation

struct Character: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let status: Status
    let species: Species
    let type: String
    let gender: Gender
    let origin: Location
    let location: Location
    let image: String
    let episode: [URL]
    let url: String
    let created: String
    var firstEpisodeName: String?

    var imgUrl: URL? {
        URL(string: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg")
    }
}
