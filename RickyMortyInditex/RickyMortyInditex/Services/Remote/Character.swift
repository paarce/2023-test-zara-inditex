//
//  Character.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let status: Status
    let species: Specie
    let type: String
    let gender: Gender
    let origin: Origin
    let location: Location
    let url: String
    let image: String
}

extension Character {

    struct Origin: Decodable {
        let name: String
        let url: String
    }

    struct Location: Decodable {
        let name: String
        let url: String
    }

    enum Gender: String, Decodable {
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown = "unknown"
    }

    enum Status: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }

    enum Specie: String, Decodable {
        case human = "Human"
        case alien = "Alien"
        case humanoid = "Humanoid"
        case poopybutthole = "Poopybutthole"
        case mythologicalCreature = "Mythological Creature"
        case Cronenberg = "Cronenberg"
        case Disease = "Disease"
        case Robot = "Robot"
        case Animal = "Animal"
        case unknown = "unknown"
    }
}

typealias CharacterList = ResponseList<Character>
