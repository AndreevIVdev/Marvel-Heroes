//
//  FullScreenAvatarPresenter.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 12.01.2022.
//

import Foundation

protocol FullScreenAvatarPresentable: AnyObject {
    func getModel()
    func handleError(error: MHError)
}

final class FullScreenAvatarPresenter: FullScreenAvatarPresentable {

    private weak var view: FullScreenAvatarViewable!
    
    private let avatarURL: URL?
    private let networkManager: NetworkManagerable!
    
    
    init(
        view: FullScreenAvatarViewable,
        avatarURL: URL?,
        networkManager: NetworkManagerable
    ) {
        self.avatarURL = avatarURL
        self.networkManager = networkManager
        self.view = view
    }
    
    func getModel() {
        guard let avatarURL = avatarURL else { return }
        networkManager.fetchData(from: avatarURL) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                self.view.set(
                    withModel: FullScreenAvatarViewModel(avatar: data)
                )
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    func handleError(error: MHError) {
        view.showAllert(
            title: "Error",
            message: error.rawValue,
            buttonTitle: "OK"
        )
    }
}
