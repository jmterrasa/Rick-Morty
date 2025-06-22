//
//  Species.swift
//  Rick&MortyApp
//
//  Created by Jaime Jesús Martínez Terrasa on 17/6/25.
//

enum Species: String, Codable, Hashable {
    case human = "Human"
    case alien = "Alien"
    case humanoid = "Humanoid"
    case poopybutthole = "Poopybutthole"
    case mythologicalCreature = "Mythological Creature"
    case animal = "Animal"
    case robot = "Robot"
    case cronenberg = "Cronenberg"
    case disease = "Disease"
    case planet = "Planet"
    case vampire = "Vampire"
    case parasite = "Parasite"
    case unknown = "unknown"
    case insect = "Insect"
    case zombie = "Zombie"

    var localized: String {
        switch self {
        case .human: return L10n.speciesHuman
        case .alien: return L10n.speciesAlien
        case .humanoid: return L10n.speciesHumanoid
        case .poopybutthole: return L10n.speciesPoopybutthole
        case .mythologicalCreature: return L10n.speciesMythologicalCreature
        case .animal: return L10n.speciesAnimal
        case .robot: return L10n.speciesRobot
        case .cronenberg: return L10n.speciesCronenberg
        case .disease: return L10n.speciesDisease
        case .planet: return L10n.speciesPlanet
        case .vampire: return L10n.speciesVampire
        case .parasite: return L10n.speciesParasite
        case .unknown: return L10n.speciesUnknown
        case .insect: return L10n.speciesInsect
        case .zombie: return L10n.speciesZombie
        }
    }
}
