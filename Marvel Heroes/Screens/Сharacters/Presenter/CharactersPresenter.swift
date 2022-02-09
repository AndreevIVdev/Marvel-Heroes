//
//  CharactersPresenter.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 02.12.2021.
//

import Foundation

protocol ChractersPresentable: AnyObject {
    func fetchCharacters(completed: @escaping () -> Void)
    func getModel(forIndex: Int, completed: @escaping (CharactersViewModel) -> Void)
    func handleError(error: mhError)
    func getCharactersCount() -> Int
    func logOutButtonTapped()
    func didSelectRowAt(indexPath: IndexPath)
}

protocol ChractersCoordinatable {
    var logOut: (() -> Void)! { get set }
    var selectCharacter: ((mhCharacter) -> Void)! { get set }
}

final class ChractersPresenter: ChractersPresentable, ChractersCoordinatable {
    private weak var view: CharacterViewable!
    private var firebaser: Firebaserable!
    private var characterNetworkManager: CharacterNetworkManagerable
    private var characters: [mhCharacter] = []
    private var isFetching = false
    
    var logOut: (() -> Void)!
    var selectCharacter: ((mhCharacter) -> Void)!
    
    init(
        view: CharacterViewable,
        characterNetworkManager: CharacterNetworkManagerable,
        firebaser: Firebaserable,
        logOut: @escaping (() -> Void),
        selectCharacter: @escaping ((mhCharacter) -> Void)
    ) {
        self.view = view
        self.characterNetworkManager = characterNetworkManager
        self.firebaser = firebaser
        self.logOut = logOut
        self.selectCharacter = selectCharacter
    }
    
    func fetchCharacters(completed: @escaping () -> Void) {
        if isFetching {
            completed()
        }
        isFetching = true
        defer {
            isFetching = false
        }
        characterNetworkManager.fetchCharacters(withOffset: characters.count) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let characters):
                self.characters += characters
                completed()
            case .failure(let error):
                self.handleError(error: error)
                completed()
            }
        }
    }
    
    func getModel(forIndex index: Int, completed: @escaping (CharactersViewModel) -> Void) {
        characterNetworkManager.getModel(character: characters[index], completed: completed)
    }
    
    func handleError(error: mhError) {
        view.showAllert(title: "Error", message: error.localizedDescription, buttonTitle: "OK")
    }

    func getCharactersCount() -> Int {
        characters.count
    }
    
    func logOutButtonTapped() {
        do {
            try firebaser.logOut()
            logOut()
        } catch {
            view.showAllert(
                title: "Error",
                message: error.localizedDescription,
                buttonTitle: "Ok"
            )
        }
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        selectCharacter(characters[indexPath.row])
    }
}
