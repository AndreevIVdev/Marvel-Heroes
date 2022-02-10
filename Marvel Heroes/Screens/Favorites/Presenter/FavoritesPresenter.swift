//
//  FavoritesPresenter.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 09.01.2022.
//

import Foundation

protocol FavoritesPresentable: AnyObject {
    func fetchFavorites()
    func getModel(forRow row: Int, completed: @escaping (FavoritesViewModel) -> Void)
    func handleError(error: MHError)
    func getFavoritesCount() -> Int
    func didSelectRowAt(indexPath: IndexPath)
    // swiftlint:disable:next identifier_name
    func moveModel(from: Int, to: Int)
    func deleteRowAt(indexPath: IndexPath)
}

protocol FavoritesCoordinatable: AnyObject {
    var selectCharacter: ((mhCharacter) -> Void)! { get set }
}

class FavoritesPresenter: FavoritesPresentable {
    
    private weak var view: FavoritesViewable!
    private let databaser: Databaserable!
    private let safeFirebaser: FirebaserReadable!
    private let favoritesNetworkManager: FavoritesNetworkManager!
    
    private var favorites: [mhCharacter] = []
    var selectCharacter: ((mhCharacter) -> Void)!
    
    init(
        view: FavoritesViewable,
        databaser: Databaserable,
        safeFirebaser: FirebaserReadable,
        favoritesNetworkManager: FavoritesNetworkManager,
        selectCharacter: ((mhCharacter) -> Void)!
    ) {
        self.view = view
        self.databaser = databaser
        self.safeFirebaser = safeFirebaser
        self.favoritesNetworkManager = favoritesNetworkManager
        self.selectCharacter = selectCharacter
    }
    
    func fetchFavorites() {
        guard let email = safeFirebaser.getEmail() else {
            handleError(error: .userHasNoEmail)
            return
        }
        view.startIndicator()
        databaser.retrieveFavorites(forEmail: email) { [weak self] result in
            guard let self = self else { return }
            self.view.stopIndicator()
            switch result {
            case .success(let ids):
                ids.isEmpty ? self.view.showEmptyStateView() : self.view.showTableView()
                DispatchQueue.main.async {
                    for (index, favorite) in self.favorites.enumerated().reversed() where !ids.contains(favorite.id) {
                        self.favorites.remove(at: index)
                        self.view.deleteRows(at: IndexPath(item: index, section: 0))
                    }
                }
                
                
                for id in ids where !self.favorites.map({ $0.id }).contains(id) {
                    self.favoritesNetworkManager.fetchCharacter(withID: id) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                            
                        case .success(let favorite):
                            DispatchQueue.main.async {
                                self.favorites.append(favorite)
                                self.view.insertRows(
                                    at: IndexPath(
                                        row: self.favorites.count - 1,
                                        section: 0
                                    )
                                )
                            }
                            
                        case .failure(let error):
                            self.handleError(error: error)
                        }
                    }
                }
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    func getModel(forRow row: Int, completed: @escaping (FavoritesViewModel) -> Void) {
        favoritesNetworkManager.getModel(character: favorites[row], completed: completed)
    }
    
    func handleError(error: MHError) {
        view.showAllert(
            title: "Error",
            message: error.rawValue,
            buttonTitle: "OK"
        )
    }
    
    func getFavoritesCount() -> Int {
        favorites.count
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        selectCharacter(favorites[indexPath.row])
    }
    
    // swiftlint:disable:next identifier_name
    func moveModel(from: Int, to: Int) {
        favorites.insert(favorites.remove(at: from), at: to)
    }
    
    func deleteRowAt(indexPath: IndexPath) {
        guard let email = safeFirebaser.getEmail() else {
            handleError(error: .userHasNoEmail)
            return
        }
        
        databaser.updateWith(
            favorite: favorites[indexPath.row].id,
            forEmail: email,
            actionType: .remove
        ) { [weak self] error in
            guard let self = self else { return }
            guard error != nil else {
                self.favorites.remove(at: indexPath.row)
                self.view.deleteRows(at: indexPath)
                if self.favorites.isEmpty {
                    self.view.showEmptyStateView()
                }
                return
            }
            self.handleError(error: .unableToRemoveCellInTableView)
        }
    }
}
