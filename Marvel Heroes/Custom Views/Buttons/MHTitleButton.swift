//
//  MHTitleButton.swift
//
//
//  Created by Илья Андреев on 20.10.2021.
//

import UIKit

final class MHTitleButton: UIButton {
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
        setTitleColor(Colors.mhLabelGray, for: .normal)
    }
}
