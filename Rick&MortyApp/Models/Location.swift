//
//  Location.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import Foundation

struct Location: Codable, Equatable, Hashable {
    let name: String
    let url: String
}

extension Location {
    var localizedName: String {
        switch name {
        case "unknown": return L10n.unknown
        case "Earth (C-137)": return L10n.locationEarthC137
        case "Citadel of Ricks": return L10n.locationCitadelOfRicks
        case "Abadango": return L10n.locationAbadango
        case "Worldender's lair": return L10n.locationWorldendersLair
        case "Anatomy Park": return L10n.locationAnatomyPark
        case "Interdimensional Cable": return L10n.locationInterdimensionalCable
        case "Immortality Field Resort": return L10n.locationImmortalityFieldResort
        case "Earth (Replacement Dimension)": return L10n.locationEarthReplacementDimension
        case "Gazorpazorp": return L10n.locationGazorpazorp
        case "Nuptia 4": return L10n.locationNuptia4
        case "Cronenberg Earth": return L10n.locationCronenbergEarth
        default: return name
        }
    }
}


