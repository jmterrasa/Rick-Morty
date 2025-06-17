//
//  AppRoute.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case characterDetail(Character, Namespace.ID)

    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case let (.characterDetail(a, _), .characterDetail(b, _)):
            return a.id == b.id
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case let .characterDetail(character, _):
            hasher.combine("characterDetail")
            hasher.combine(character.id)
        }
    }
}
