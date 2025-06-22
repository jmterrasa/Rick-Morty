//
//  Favorite.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteCharacter: Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    var image: String
    var imageData: Data?
    var status: String
    var species: String
    var gender: String
    var originName: String
    var locationName: String
    var firstEpisodeName: String?

   
    init(id: Int, name: String, image: String, imageData: Data?, status: String, species: String, gender: String, originName: String, locationName: String, firstEpisodeName: String?) {
        self.id = id
        self.name = name
        self.image = image
        self.imageData = imageData
        self.status = status
        self.species = species
        self.gender = gender
        self.originName = originName
        self.locationName = locationName
        self.firstEpisodeName = firstEpisodeName
    }
}

