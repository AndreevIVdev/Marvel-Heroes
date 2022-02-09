//
//  mhCharacterCoordinator.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 05.01.2022.
//

import UIKit

final class mhCharactersCoordinator: mhCoordinatable {
    var completed: (() -> Void)!
    
    private let charactersNavigationController: UINavigationController!
    private let favoritesNavigationController: UINavigationController!
    private let charactersTabBarController: UITabBarController!
    private let factory: mhScreensFactorable!
    private let strategy: mhStrategy!
    private let window: UIWindow!
    
    init(
        factory: mhScreensFactorable,
        strategy: mhStrategy,
        window: UIWindow,
        completed: @escaping () -> Void
    ) {
        charactersNavigationController = UINavigationController()
        favoritesNavigationController = UINavigationController()
        charactersTabBarController = UITabBarController()
        self.factory = factory
        self.strategy = strategy
        self.window = window
        self.completed = completed
        configureTabBarController()
    }
    
    func start() {
        window.rootViewController = charactersTabBarController
        showCharactersScreen()
    }
    
    private func showCharactersScreen() {
        charactersNavigationController.viewControllers = []
        charactersNavigationController.pushViewController(
            factory.makeCharactersScreen { [weak self] in
                self?.completed()
            }
            selectCharacter: { [weak self] character in
                self?.showDetailedInformationScreen(character: character)
            },
            animated: true
        )
    }
    
    private func showDetailedInformationScreen(character: mhCharacter) {
        charactersNavigationController.pushViewController(
            factory.makeDetailedInformationScreen(
                character: character
            ) { [weak self] url in
                self?.showFullScreenAvatarScreen(avatarURL: url)
            },
            animated: true
        )
    }
    
    private func showFullScreenAvatarScreen(avatarURL: URL?) {
        charactersNavigationController.pushViewController(
            factory.makeFullScreenAvatarScreen(
                avatarURL: avatarURL,
                strategy: strategy
            ),
            animated: true
        )
    }
    
    private func configureTabBarController() {
        let favoritesScreen: FavoritesViewController = factory.makeFavoritesScreen(
            strategy: strategy
        ) { [weak self] character in
            guard let self = self else {
                return
            }
            
            guard let navigationController = self.charactersTabBarController.selectedViewController
                    as? UINavigationController else {
                return
            }
            
            navigationController.pushViewController(
                self.factory.makeDetailedInformationScreen(
                    character: character) { [weak self] url in
                        guard let self = self else { return }
                        guard let navigationController = self.charactersTabBarController.selectedViewController
                                as? UINavigationController else {
                            return
                        }
                        navigationController.pushViewController(
                            self.factory.makeFullScreenAvatarScreen(
                                avatarURL: url,
                                strategy: self.strategy
                            ),
                            animated: true
                        )
                },
                animated: true
            )
        }
        
        charactersNavigationController.tabBarItem.title = "Characters"
        charactersNavigationController.tabBarItem.image = Images.person
        
        favoritesNavigationController.tabBarItem.title = "Favorites"
        favoritesNavigationController.tabBarItem.image = Images.emptyStar
        
        favoritesNavigationController.viewControllers = [favoritesScreen]
        charactersTabBarController.viewControllers = [
            charactersNavigationController, favoritesNavigationController
        ]
    }
}
