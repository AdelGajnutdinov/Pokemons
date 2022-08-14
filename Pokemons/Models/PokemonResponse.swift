//
//  PokemonResponse.swift
//  Pokemons
//
//  Created by Adel Gainutdinov on 14.08.2022.
//

import Foundation

// MARK: - PokemonResponse
struct PokemonList: Decodable {
    let results: [Pokemon]
}

// MARK: - Pokemon
struct Pokemon: Decodable {
    let name: String
}
