//
//  CharacterNetworkManager.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 11.12.2021.
//

import Foundation

protocol CharacterNetworkManagerable: AnyObject {
    func fetchCharacters(withOffset offset: Int, completed: @escaping (Result<[mhCharacter], mhError>) -> Void)
    func getModel(character: mhCharacter, completed: @escaping (CharactersViewModel) -> Void)
}

final class CharacterNetworkManager: CharacterNetworkManagerable {
    var networkManager: NetworkManagerable
    var urlGenerator: URLGeneratorable
    init(networkManager: NetworkManagerable, urlGenerator: URLGeneratorable) {
        self.networkManager = networkManager
        self.urlGenerator = urlGenerator
    }

    func fetchCharacters(withOffset offset: Int, completed: @escaping (Result<[mhCharacter], mhError>) -> Void) {
        
        guard let url = urlGenerator.getAllCharactersURL(
            withOffset: offset
        ) else {
            completed(.failure(.invalidURL))
            return
        }
        networkManager.fetchData(from: url) {result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(
                        CharactersResponse.self,
                        from: data
                    )
                    completed(.success(response.data.characters))
                } catch {
                    completed(.failure(.invalidData))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func getModel(character: mhCharacter, completed: @escaping (CharactersViewModel) -> Void) {
        guard let url = urlGenerator.getAvatarURL(
            path: character.thumbnail.path,
            ext: character.thumbnail.thumbnailExtension.rawValue
        ) else {
            completed(CharactersViewModel(name: character.name, avatar: nil))
            return
        }
        networkManager.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                completed(CharactersViewModel(name: character.name, avatar: data))
            default:
                print()
            }
        }
    }
}
