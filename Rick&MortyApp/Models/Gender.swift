//
//  Gender.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import Foundation

enum Gender: String, Codable, Hashable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"

    var localized: String {
        switch self {
        case .female:
            return L10n.genderFemale
        case .male:
            return L10n.genderMale
        case .genderless:
            return L10n.genderGenderless
        case .unknown:
            return L10n.genderUnknown
        }
    }
}
