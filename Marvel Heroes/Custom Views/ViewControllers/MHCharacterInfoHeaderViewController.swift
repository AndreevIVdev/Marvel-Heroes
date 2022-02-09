//
//  MHCharacterInfoHeaderViewController.swift
//
//
//  Created by Илья Андреев on 02.01.2022.
//

import UIKit
import Kingfisher

final class MHCharacterInfoHeaderViewController: UIViewController {
    
    private let avatarImageView: MHAvatarImageView = .init(frame: .zero)
    private let nameLabel: MHTitleLabel = .init(textAlignment: .left, fontSize: 34)
    private let idLabel: MHSecondaryTitleLabel = .init(fontSize: 18)
    private let editedImageView: UIImageView = .init()
    private let editedLabel: MHSecondaryTitleLabel = .init(fontSize: 18)
    private let descriptionLabel: MHBodyLabel = .init(textAlignment: .left)
    
    private let avatarTapped: (() -> Void)!
    
    init(avatarTapped: @escaping (() -> Void)) {
        self.avatarTapped = avatarTapped
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(
            avatarImageView,
            nameLabel,
            idLabel,
            editedImageView,
            editedLabel,
            descriptionLabel
        )
        configureAvatarImageView()
        layoutUI()
    }
    
    private func layoutUI() {
        let padding: CGFloat = 28
        let textImagePadding: CGFloat = 12
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        editedImageView.translatesAutoresizingMaskIntoConstraints = false
        editedLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            idLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            idLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            idLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            idLabel.heightAnchor.constraint(equalToConstant: 20),
            
            editedImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            editedImageView.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: textImagePadding
            ),
            editedImageView.widthAnchor.constraint(equalToConstant: 20),
            editedImageView.heightAnchor.constraint(equalToConstant: 20),
            
            editedLabel.centerYAnchor.constraint(equalTo: editedImageView.centerYAnchor),
            editedLabel.leadingAnchor.constraint(equalTo: editedImageView.trailingAnchor, constant: 5),
            editedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editedLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func configureUI(
        avatarURL: URL?,
        name: String,
        id: Int,
        modified: Date,
        description: String
    ) {
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: avatarURL)
        nameLabel.text = name
        idLabel.text = "id: " + String(id)
        editedImageView.image = Images.edited
        editedLabel.text = modified.convertToMonthYearFormat()
        descriptionLabel.text = !description.isEmpty ? description : "No description available."
        descriptionLabel.numberOfLines = 0
    }
    
    private func configureAvatarImageView() {
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(avatarTap)
            )
        )
    }
    
    @objc private func avatarTap() {
        avatarTapped()
    }
}
