//
//  mhMainCoordinator.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 05.01.2022.
//

import UIKit

final class mhMainCoordinator: mhCoordinatable {
    var completed: (() -> Void)!
    
    private let factory: mhScreensFactorable!
    private let strategy: mhStrategy!
    private let window: UIWindow!
    private var loginCoordinator: mhLoginCoordinator!
    private var  charactersCoordinator: mhCharactersCoordinator!
    
    init(
        factory: mhScreensFactorable,
        strategy: mhStrategy,
        window: UIWindow,
        completed: @escaping () -> Void
    ) {
        self.factory = factory
        self.strategy = strategy
        self.window = window
        self.completed = completed
    }
    
    func start() {
        if strategy.firebaser.isLoggedIn() {
            charactersCoordinator = .init(
                factory: factory,
                strategy: strategy,
                window: window
            ) { [weak self] in
                self?.start()
            }
            charactersCoordinator.start()
        } else {
            loginCoordinator = .init(
                factory: factory,
                strategy: strategy,
                window: window
            ) { [weak self] in
                self?.start()
            }
            loginCoordinator.start()
        }
    }
}
