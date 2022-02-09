//
//  UIStackView+Ext.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 21.10.2021.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ textFields: UITextField...) {
        textFields.forEach {
            self.addArrangedSubview($0)
        }
    }
}
