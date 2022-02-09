//
//  Router.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 17.11.2021.
//

import UIKit

protocol mhCoordinatable: AnyObject {
    func start()
    var completed: (() -> Void)! { get set }
}

final class mhLoginCoordinator: mhCoordinatable {
    var completed: (() -> Void)!
    private let loginNavigationController: UINavigationController!
    private let factory: mhScreensFactorable!
    private let strategy: mhStrategy!
    private let window: UIWindow!
    
    init(
        factory: mhScreensFactorable,
        strategy: mhStrategy,
        window: UIWindow,
        completed: @escaping () -> Void
    ) {
        loginNavigationController = UINavigationController()
        self.factory = factory
        self.strategy = strategy
        self.window = window
        self.completed = completed
    }
    
    func start() {
        window.rootViewController = loginNavigationController
        showLoginScreen()
    }
    
    private func showLoginScreen() {
        loginNavigationController.viewControllers = [
            factory.makeLoginScreen { [weak self] in
                guard let self = self else { return }
                self.completed()
            } noAccount: { [weak self] in
                guard let self = self else { return }
                self.showCreateAccountScreen()
            } forgotPassword: { [weak self] in
                guard let self = self else { return }
                self.showSendRecoveryCodeScreen()
            }
        ]
    }
    
    private func showCreateAccountScreen() {
        loginNavigationController.pushViewController(
            factory.makeCreateAccountScreen { [weak self] in
                guard let self = self else { return }
                self.showLoginScreen()
            } termsAgreed: {
                print(#function)
            } alreadyHaveAnAccount: { [weak self] in
                guard let self = self else { return }
                self.loginNavigationController.popViewController(animated: true)
            },
            animated: true
        )
    }
    
    private func showSendRecoveryCodeScreen() {
        loginNavigationController.pushViewController(
            factory.makeSendRecoveryCodeScreen { [weak self] in
                self?.start()
            },
            animated: true
        )
    }
}
