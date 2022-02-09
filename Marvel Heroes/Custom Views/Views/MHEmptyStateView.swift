//
//  MHEmptyStateView.swift
//
//
//  Created by Илья Андреев on 05.01.2022.
//

import UIKit

final class MHEmptyStateView: UIView {
    
    private let messageLabel: MHTitleLabel = .init(textAlignment: .center, fontSize: 28)
    private let logoImageView: UIImageView = .init(image: Images.emptyStateLogo)
    
    init(message: String) {
        super.init(frame: .zero)
        configure()
        configureLogoImageView()
        configureMessageLabel()
        messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubViews(logoImageView, messageLabel)
    }
    
    private func configureLogoImageView() {
        logoImageView.image = Images.emptyStateLogo
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            messageLabel.widthAnchor.constraint(equalToConstant: 200),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
