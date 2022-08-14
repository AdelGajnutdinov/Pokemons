//
//  NetworkDataFetcher.swift
//  Pokemons
//
//  Created by Adel Gainutdinov on 14.08.2022.
//

import Foundation

protocol DataFetcher {
    func fetchPokemons(completion: @escaping ([Pokemon]) -> ())
    func fetchPokemon(by searchString: String, completion: @escaping (Pokemon?) -> ())
}

class NetworkDataFetcher: DataFetcher {
    
    func fetchPokemons(completion: @escaping ([Pokemon]) -> ()) {
        guard let url = url(from: Constants.API.Poke.pokemonMethod) else {
            print("Bad URL")
            return
        }
        fetchPokemons(PokemonList.self, url: url) { fetchedPokemons in
            var pokemons: [Pokemon] = []
            if let fetchedPokemons = fetchedPokemons {
                pokemons = fetchedPokemons.results.sorted { $0.name < $1.name }
            }
            completion(pokemons)
        }
    }
    
    func fetchPokemon(by searchString: String, completion: @escaping (Pokemon?) -> ()) {
        guard let url = url(from: Constants.API.Poke.pokemonMethod, searchString: searchString.lowercased()) else {
            print("Bad URL")
            return
        }
        fetchPokemons(Pokemon.self, url: url) { pokemon in
            completion(pokemon)
        }
    }
    
    private func fetchPokemons<T: Decodable>(_ model: T.Type, url: URL, completion: @escaping (T?) -> ()) {
        print(url)
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else { return }
            
            let responseString = String(data: data, encoding: .utf8)
            if responseString == Constants.API.Poke.errorResponse {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }.resume()
    }
    
    private func url(from path: String, searchString: String? = nil) -> URL? {
        var components = URLComponents()
        
        components.scheme = Constants.API.Poke.scheme
        components.host = Constants.API.Poke.host
        components.path = "\(path)"
        
        if let searchString = searchString {
            components.path += "/\(searchString)"
        }
        components.queryItems = [
            URLQueryItem(name: "limit", value: "1000"),
            URLQueryItem(name: "offset", value: "0"),
        ]
        
        return components.url
    }
}
