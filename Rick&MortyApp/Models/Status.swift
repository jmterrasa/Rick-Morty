//
//  Status.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import Foundation

enum Status: String, Codable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"

    var localized: String {
        switch self {
        case .alive: return L10n.statusAlive
        case .dead: return L10n.statusDead
        case .unknown: return L10n.statusUnknown
        }
    }
}
