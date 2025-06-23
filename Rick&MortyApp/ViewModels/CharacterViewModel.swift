//
//  CharacterViewModel.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 23/6/25.
//
import Foundation

struct CharacterViewModel: Identifiable {
    let id: Int
    let name: String
    let imageURL: URL?
    let species: String
    let status: String
    let location: Location
    let origin: Location
    let gender: Gender
    let firstEpisodeName: String?
    let statusRaw: Status
    let speciesRaw: Species
    
    init(from character: Character) {
        self.id = character.id
        self.name = character.name
        self.imageURL = URL(string: character.image)
        self.species = character.species.localized
        self.status = character.status.localized
        self.location = character.location
        self.origin = character.origin
        self.gender = character.gender
        self.firstEpisodeName = character.firstEpisodeName
        self.statusRaw = character.status
        self.speciesRaw = character.species
    }
}
