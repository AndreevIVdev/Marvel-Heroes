//
//  MHBodyLabel.swift
//
//
//  Created by Илья Андреев on 02.01.2022.
//

import UIKit

final class MHBodyLabel: UILabel {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        configure()
        self.textAlignment = textAlignment
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.1
        lineBreakMode = .byTruncatingTail
    }
}
