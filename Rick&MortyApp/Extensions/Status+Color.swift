//
//  StatusColor.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 17/6/25.
//

import SwiftUI

extension Status {
    var color: Color {
        switch self {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
}
