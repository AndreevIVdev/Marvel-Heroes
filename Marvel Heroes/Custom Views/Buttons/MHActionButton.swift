//
//  MHButton.swift
//
//
//  Created by Илья Андреев on 15.10.2021.
//

import UIKit

final class MHActionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont(name: Fonts.openSansBold, size: 16)
        backgroundColor = Colors.mhRed
    }
}
