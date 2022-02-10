//
//  FavoritesNetworkManager.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 07.01.2022.
//

import Foundation

protocol FavoritesNetworkManagerable: AnyObject {
    func fetchCharacter(withID id: Int, completed: @escaping (Result<mhCharacter, MHError>) -> Void)
    // func getModel(character: mhCharacter, completed: @escaping (CharactersViewModel) -> Void)
}

class FavoritesNetworkManager: FavoritesNetworkManagerable {
    var networkManager: NetworkManagerable
    var urlGenerator: URLGeneratorable
    
    init(networkManager: NetworkManagerable, urlGenerator: URLGeneratorable) {
        self.networkManager = networkManager
        self.urlGenerator = urlGenerator
    }

    func fetchCharacter(
        withID id: Int,
        completed: @escaping (Result<mhCharacter, MHError>) -> Void
    ) {
        guard let url = urlGenerator.getCharacterURLbyID(id: id) else {
            completed(.failure(.invalidURL))
            return
        }
        networkManager.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(
                        CharactersResponse.self,
                        from: data
                    )
                    completed(.success(response.data.characters[0]))
                } catch {
                    completed(.failure(.invalidData))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func getModel(character: mhCharacter, completed: @escaping (FavoritesViewModel) -> Void) {
        guard let url = urlGenerator.getAvatarURL(
            path: character.thumbnail.path,
            ext: character.thumbnail.thumbnailExtension.rawValue
        ) else {
            completed(FavoritesViewModel(name: character.name, avatar: nil))
            return
        }
        networkManager.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                completed(FavoritesViewModel(name: character.name, avatar: data))
            default:
                print()
            }
        }
    }
}
