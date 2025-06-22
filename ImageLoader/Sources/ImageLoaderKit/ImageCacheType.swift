//
//  Untitled.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 13/6/25.
//

import Foundation
import SwiftUI

public protocol ImageCacheType {
    subscript(_ url: URL) -> UIImage? { get set }
}






