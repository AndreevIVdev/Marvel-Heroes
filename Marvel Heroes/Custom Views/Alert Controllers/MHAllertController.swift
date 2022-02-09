//
//  mhAllertController.swift
//  
//
//  Created by Илья Андреев on 15.10.2021.
//

import UIKit

final class MHAlertViewController: UIViewController {
    private let containerView: UIView = .init()
    private let titleLabel: MHLabel = .init()
    private let messageLabel: MHLabel = .init()
    private let actionButton: MHActionButton = .init()

    private var alertTitle: String?
    private var message: String?
    private var buttonTitle: String?
    private var completion: (() -> Void)?

    private let padding: CGFloat = 20

    init(
        alertTitle: String,
        message: String,
        buttonTitle: String,
        completion: (() -> Void)? = nil
    ) {
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        view.addSubViews(
            containerView,
            titleLabel,
            actionButton,
            messageLabel
        )
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }

    @objc private func dismissViewController() {
        dismiss(animated: true)
        completion?()
    }

    private func configureViewController() {
        view.backgroundColor = .black.withAlphaComponent(0.75)
    }

    private func configureContainerView() {
        containerView.backgroundColor = Colors.mhwhite
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = Colors.mhRed.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong!"
        titleLabel.font = UIFont(name: Fonts.openSansBold, size: 20)
        titleLabel.textColor = Colors.mhLabelGray
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func configureMessageLabel() {
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        messageLabel.font = UIFont(name: Fonts.openSansRegular, size: 14)
        messageLabel.textColor = Colors.mhLabelGray
        messageLabel.textAlignment = .left
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

    private func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
