//
//  MHTableViewCell.swift
//
//
//  Created by Илья Андреев on 02.12.2021.
//

import UIKit

final class MHTableViewCell: UITableViewCell {
    
    let avatarImageView = MHAvatarImageView(frame: .zero)
    let nameLabel = MHTitleLabel(textAlignment: .left, fontSize: 14)
    var id: UUID!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.setDefaultImage()
        nameLabel.text = nil
        id = UUID()
    }
    
    private func configure() {
        contentView.backgroundColor = Colors.mhwhite
        addSubViews(avatarImageView, nameLabel)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func getSnapshot(inputView: UIView) -> UIView? {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        inputView.layer.render(in: currentContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        let cellSnapshot = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
}
