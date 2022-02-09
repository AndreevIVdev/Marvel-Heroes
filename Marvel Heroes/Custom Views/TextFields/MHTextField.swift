//
//  MHTextField.swift
//
//
//  Created by Илья Андреев on 15.10.2021.
//

import UIKit

final class MHTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        textColor = Colors.mhLabelGray
        font = UIFont(name: Fonts.openSansRomanSemiBold, size: 14)
        adjustsFontSizeToFitWidth = true
        backgroundColor = .white
        minimumFontSize = 12
        autocorrectionType = .no
        keyboardType = .default
        clearButtonMode = .whileEditing
        leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 20, height: 50)
        )
        leftViewMode = .always
    }
}
