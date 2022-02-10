//
//  DetailedInformationPresenter.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 03.01.2022.
//

import Foundation
import SafariServices

protocol DetailedInformationPresentable: AnyObject {
    func handleError(error: MHError)
    func updateIsInFavorites()
    func getModel() -> DetailedInformationViewModel
    func favouriteButtonTapped()
    func avatarImageTapped()
    func comicsButtonTapped() -> (() -> Void)
    func wikiButtonTapped() -> (() -> Void)
}

protocol DetailedInformationCoordinatable: AnyObject {
    var avatarTapped: ((URL?) -> Void)! { get set }
}

class DetailedInformationPreseneter: DetailedInformationPresentable, DetailedInformationCoordinatable {
    private weak var view: DetailedInformationViewable!
    private let character: mhCharacter!
    private let urlGenerator: URLGeneratorable!
    private let dataBaser: Databaserable!
    private let firebaseReader: FirebaserReadable!
    
    var avatarTapped: ((URL?) -> Void)!
    
    private var isInFavorites: Bool? {
        didSet {
            guard let isInFavorites = isInFavorites else {
                handleError(error: .favoritingError)
                return
            }
            view.setFavoriteButton(isInFavorites: isInFavorites)
        }
    }
    
    init(
        view: DetailedInformationViewable,
        character: mhCharacter,
        urlGenerator: URLGeneratorable,
        dataBaser: Databaserable,
        firebaseReader: FirebaserReadable,
        avatarTapped: @escaping ((URL?) -> Void)
    ) {
        self.view = view
        self.character = character
        self.urlGenerator = urlGenerator
        self.dataBaser = dataBaser
        self.firebaseReader = firebaseReader
        self.avatarTapped = avatarTapped
    }
    
    func handleError(error: MHError) {
        view.showAllert(title: "Error", message: error.localizedDescription, buttonTitle: "OK")
    }
    
    func updateIsInFavorites() {
        
        guard let email = firebaseReader.getEmail() else {
            handleError(error: .userHasNoEmail)
            return
        }
        
        dataBaser.isInFavorites(id: character.id, email: email) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let isInFavorites):
                self.isInFavorites = isInFavorites
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    func getModel() -> DetailedInformationViewModel {
        DetailedInformationViewModel(
            avatarURL: urlGenerator.getAvatarURL(
                path: character.thumbnail.path,
                ext: character.thumbnail.thumbnailExtension.rawValue
            ),
            name: character.name,
            id: character.id,
            modified: character.modified,
            description: character.description,
            comicsCount: character.comics.available,
            seriesCount: character.series.available,
            storiesCount: character.stories.available,
            eventsCount: character.events.available,
            comicsURL: URL(string: character.comics.collectionURI),
            storiesURL: URL(string: character.stories.collectionURI)
        )
    }
    
    func favouriteButtonTapped() {
        guard let isInFavorites = isInFavorites else { return }
        guard let email = firebaseReader.getEmail() else {
            handleError(error: .userHasNoEmail)
            return
        }
        dataBaser.updateWith(
            favorite: character.id,
            forEmail: email,
            actionType: isInFavorites ? .remove : .add
        ) { [weak self] error in
            guard let self = self else { return }
            guard error != nil else {
                self.isInFavorites!.toggle()
                return
            }
            self.handleError(error: .favoritingError)
            self.isInFavorites = nil
        }
    }
    
    func avatarImageTapped() {
        avatarTapped(
            urlGenerator.getAvatarURL(
                path: character.thumbnail.path,
                ext: character.thumbnail.thumbnailExtension.rawValue
            )
        )
    }
    
    func comicsButtonTapped() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            print(self.character.urls)
            guard let adress = self.character.urls.first(where: { element in
                element.type == "comiclink"
            }) else {
                self.handleError(error: .noComics)
                return
            }
            guard let url = self.urlGenerator.makeUrlWithValidKey(
                from: adress.url
            ) else { return }
            let safariViewController = SFSafariViewController(
                url: url
            )
            safariViewController.preferredControlTintColor = Colors.mhLabelGray
            self.view.present(toPresent: safariViewController)
        }
    }
    
    func wikiButtonTapped() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            guard let adress = self.character.urls.first(where: { element in
                element.type == "wiki" || element.type == "details"
            }) else {
                self.handleError(error: .noWiki)
                return
            }
            guard let url = self.urlGenerator.makeUrlWithValidKey(
                from: adress.url
            ) else { return }
            let safariViewController = SFSafariViewController(
                url: url
            )
            safariViewController.preferredControlTintColor = Colors.mhLabelGray
            self.view.present(toPresent: safariViewController)
        }
    }
}
