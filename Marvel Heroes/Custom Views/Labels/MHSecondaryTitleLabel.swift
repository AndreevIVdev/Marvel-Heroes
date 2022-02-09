//
//  MHSecondaryTitleLabel.swift
//
//
//  Created by Илья Андреев on 02.01.2022.
//

import UIKit

final class MHSecondaryTitleLabel: UILabel {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        configure()
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
    }
}
