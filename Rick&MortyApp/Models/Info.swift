//
//  Info.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 12/6/25.
//

import Foundation

struct Info: Codable, Equatable, Hashable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
