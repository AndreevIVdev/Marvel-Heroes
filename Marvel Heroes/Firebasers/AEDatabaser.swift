//
//  mhDatabaser.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 03.01.2022.
//

import FirebaseDatabase

protocol Databaserable: AnyObject {
    func isInFavorites(
        id: Int,
        email: String,
        completed: @escaping (Result<Bool, MHError>) -> Void
    )
    
    func updateWith(
        favorite: Int,
        forEmail email: String,
        actionType: DatabaserActionType,
        completed: @escaping (MHError?) -> Void
    )
    
    func retrieveFavorites(
        forEmail email: String,
        completed: @escaping (Result<[Int], MHError>) -> Void
    )
}

enum DatabaserActionType {
    case add, remove
}

final class mhDatabaser: Databaserable {
    private var database: DatabaseReference! = Database.database().reference()
    
    func isInFavorites(
        id: Int,
        email: String,
        completed: @escaping (Result<Bool, MHError>) -> Void
    ) {
        retrieveFavorites(forEmail: email) { result in
            switch result {
                
            case .success(let ints):
                completed(.success(ints.contains(id)))
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func updateWith(
        favorite: Int,
        forEmail email: String,
        actionType: DatabaserActionType,
        completed: @escaping (MHError?) -> Void
    ) {
        
        retrieveFavorites(forEmail: email) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {

            case .success(var favorites):
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                    
                case .remove:
                    guard favorites.contains(favorite) else {
                        completed(.isNotInFavorites)
                        return
                    }
                    favorites.removeAll(where: { $0 == favorite })
                }
                self.save(forEmail: email, favorites: favorites, complititon: completed)
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    func retrieveFavorites(
        forEmail email: String,
        completed: @escaping (Result<[Int], MHError>) -> Void
    ) {
        database.child(MD5(string: email)).getData { error, snapshot  in
            guard error == nil else {
                completed(.failure(.dataBaseError))
                return
            }
            if let result = snapshot.value as? [Int] {
                completed(.success(result))
            } else {
                completed(.success([]))
            }
        }
    }
    
    private func save(
        forEmail email: String,
        favorites: [Int],
        complititon: @escaping (MHError?) -> Void
    ) {
        database.child(MD5(string: email)).setValue(favorites) { error, _ in
            complititon(error != nil ? .dataBaseError : nil)
        }
    }
}
