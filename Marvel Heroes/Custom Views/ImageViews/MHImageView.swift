//
//  MHImageView.swift
//
//
//  Created by Илья Андреев on 02.12.2021.
//

import UIKit

final class MHAvatarImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaultImage() {
        image = Images.placeholder
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        setDefaultImage()
    }
}
