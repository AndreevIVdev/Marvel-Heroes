//
//  MHTitleLabel.swift
//
//
//  Created by Илья Андреев on 02.12.2021.
//

import UIKit

final class MHTitleLabel: UILabel {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        configure()
        self.textAlignment = textAlignment
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
    }
}
