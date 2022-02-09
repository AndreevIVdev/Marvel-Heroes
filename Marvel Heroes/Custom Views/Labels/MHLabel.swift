//
//  MHLabel.swift
//
//
//  Created by Илья Андреев on 15.10.2021.
//

import UIKit

final class MHLabel: UILabel {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        textAlignment = .center
    }
}
