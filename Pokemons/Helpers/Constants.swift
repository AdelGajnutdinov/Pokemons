//
//  Constants.swift
//  Pokemons
//
//  Created by Adel Gainutdinov on 14.08.2022.
//

import Foundation

enum Constants {
    enum API {
        enum Poke {
            static let scheme = "https"
            static let host = "pokeapi.co"
            static let pokemonMethod = "/api/v2/pokemon/"
            static let errorResponse = "Not Found"
        }
    }
    
    enum Text {
        static let searchInProgress = "Loading..."
        static let notFoundTitle = "Not found"
        static let notFoundMessage = "Please try again"
        
        static let selectedTitle = "Here is your Pokemon!"
    }
}
