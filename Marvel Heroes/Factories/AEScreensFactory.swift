//
//  mhScreensAssembly.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 23.12.2021.
//

import Foundation

protocol mhScreensFactorable: AnyObject {
    
    func makeLoginScreen(
        signIn: @escaping () -> Void,
        noAccount: @escaping () -> Void,
        forgotPassword: @escaping () -> Void
    ) -> LoginViewController
    
    func makeCreateAccountScreen(
        createAccount: @escaping () -> Void,
        termsAgreed: @escaping () -> Void,
        alreadyHaveAnAccount: @escaping () -> Void
    ) -> CreateAccountViewController
    
    func makeSendRecoveryCodeScreen(
        sendCode: @escaping () -> Void
    ) -> SendRecoveryCodeViewController
    
    func makeCharactersScreen(
        logOut: @escaping () -> Void,
        selectCharacter: @escaping (mhCharacter) -> Void
    ) -> CharacterViewController
    
    func makeDetailedInformationScreen(
        character: mhCharacter,
        avatarTapped: @escaping (URL?) -> Void
    ) -> DetailedInformationViewController
    
    func makeFavoritesScreen(
        strategy: mhStrategy,
        selectFavoritedCharacter: @escaping (mhCharacter) -> Void
    ) -> FavoritesViewController
    
    func makeFullScreenAvatarScreen(
        avatarURL: URL?,
        strategy: mhStrategy
    ) -> FullScreenAvatarViewController
}

final class mhScreensFactory: mhScreensFactorable {
    
    private let strategy: mhStrategy!
    
    init(strategy: mhStrategy) {
        self.strategy = strategy
    }
    
    func makeLoginScreen(
        signIn: @escaping () -> Void,
        noAccount: @escaping () -> Void,
        forgotPassword: @escaping () -> Void
    ) -> LoginViewController {
        let view: LoginViewController = .init()
        let presenter = LoginPresenter(view: view, firebaser: strategy.firebaser)
        presenter.signIn = signIn
        presenter.noAccount = noAccount
        presenter.forgotPassword = forgotPassword
        view.presenter = presenter
        return view
    }
    
    func makeCreateAccountScreen(
        createAccount: @escaping () -> Void,
        termsAgreed: @escaping () -> Void,
        alreadyHaveAnAccount: @escaping () -> Void
    ) -> CreateAccountViewController {
        let view: CreateAccountViewController = .init()
        let presenter = CreateAccountPresenter(
            view: view,
            firebaser: strategy.firebaser
        )
        presenter.createAccount = createAccount
        presenter.termsAgreed = termsAgreed
        presenter.alreadyHaveAnAccount = alreadyHaveAnAccount
        view.presenter = presenter
        return view
    }
    
    func makeSendRecoveryCodeScreen(sendCode: @escaping () -> Void) -> SendRecoveryCodeViewController {
        let view: SendRecoveryCodeViewController = .init()
        let presenter = SendRecoveryPresenter(view: view, firebaser: strategy.firebaser)
        presenter.sendCode = sendCode
        view.presenter = presenter
        return view
    }
    
    func makeCharactersScreen(
        logOut: @escaping () -> Void,
        selectCharacter: @escaping (mhCharacter) -> Void
    ) -> CharacterViewController {
        let view: CharacterViewController = .init()
        let presenter = ChractersPresenter(
            view: view,
            characterNetworkManager: CharacterNetworkManager(
                networkManager: strategy.networkManager,
                urlGenerator: strategy.urlGenerator
            ),
            firebaser: strategy.firebaser,
            logOut: logOut,
            selectCharacter: selectCharacter
        )
        view.presenter = presenter
        return view
    }
    
    func makeDetailedInformationScreen(
        character: mhCharacter,
        avatarTapped: @escaping (URL?) -> Void
    ) -> DetailedInformationViewController {
        let view: DetailedInformationViewController = .init()
        let presenter: DetailedInformationPreseneter = .init(
            view: view,
            character: character,
            urlGenerator: strategy.urlGenerator,
            dataBaser: strategy.databaser,
            firebaseReader: strategy.firebaser,
            avatarTapped: avatarTapped
        )
        view.presenter = presenter
        return view
    }
    
    func makeFavoritesScreen(
        strategy: mhStrategy,
        selectFavoritedCharacter: @escaping (mhCharacter) -> Void
    ) -> FavoritesViewController {
        let view: FavoritesViewController = .init()
        let presenter: FavoritesPresenter = .init(
            view: view,
            databaser: strategy.databaser,
            safeFirebaser: strategy.firebaser,
            favoritesNetworkManager: FavoritesNetworkManager(
                networkManager: strategy.networkManager,
                urlGenerator: strategy.urlGenerator
            ),
            selectCharacter: selectFavoritedCharacter
        )
        view.presenter = presenter
        return view
    }
    
    func makeFullScreenAvatarScreen(
        avatarURL: URL?,
        strategy: mhStrategy
    ) -> FullScreenAvatarViewController {
        let view: FullScreenAvatarViewController = .init()
        let presenter: FullScreenAvatarPresenter = .init(
            view: view,
            avatarURL: avatarURL,
            networkManager: strategy.networkManager
        )
        view.presenter = presenter
        return view
    }
}
