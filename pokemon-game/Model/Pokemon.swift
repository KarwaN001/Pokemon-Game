//
//  Pokemon.swift
//  pokemon-game
//
//  Created by karwan Syborg on 02/09/2025.
//

import Foundation

struct Pokemon {
    let id: Int
    let name: String
    let imageURL: String
    let options: [String] // Multiple choice options including the correct answer
}

// Mock data for testing
extension Pokemon {
    static let mockPokemons: [Pokemon] = [
        Pokemon(
            id: 25,
            name: "pikachu",
            imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png",
            options: ["pikachu", "raichu", "pichu", "voltorb"]
        ),
        Pokemon(
            id: 1,
            name: "bulbasaur",
            imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
            options: ["bulbasaur", "ivysaur", "venusaur", "oddish"]
        ),
        Pokemon(
            id: 4,
            name: "charmander",
            imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png",
            options: ["charmander", "charmeleon", "charizard", "growlithe"]
        ),
        Pokemon(
            id: 7,
            name: "squirtle",
            imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png",
            options: ["squirtle", "wartortle", "blastoise", "psyduck"]
        ),
        Pokemon(
            id: 150,
            name: "mewtwo",
            imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/150.png",
            options: ["mewtwo", "mew", "alakazam", "hypno"]
        )
    ]
} 