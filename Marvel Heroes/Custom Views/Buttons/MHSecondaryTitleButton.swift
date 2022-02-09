//
//  MHSecondaryTitle.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 20.10.2021.
//

import UIKit

final class MHSecondaryTitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(Colors.mhLabelGray, for: .normal)
        titleLabel?.font = UIFont(name: Fonts.openSansRomanSemiBold, size: 14)
    }
}
