//
//  UITextField+Ext.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 15.10.2021.
//

import Foundation
import UIKit

extension UITextField {
    var isEntered: Bool {
        guard let text = self.text else {
            return false
        }
        
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func shake(
        horizantaly: CGFloat = 0,
        verticaly: CGFloat = 0,
        duration: CFTimeInterval = 0
    ) {
        let animation: CABasicAnimation = .init(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - horizantaly, y: center.y - verticaly ))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + horizantaly, y: center.y + verticaly ))
        layer.add(animation, forKey: "position")
    }
    
    func animateColor(
        toColor: CGColor,
        duration: CFTimeInterval
    ) {
        let animation: CABasicAnimation = .init(keyPath: "backgroundColor")
        animation.fromValue = toColor
        animation.toValue = backgroundColor
        animation.duration = duration
        animation.repeatCount = 5
        animation.autoreverses = true
        layer.add(animation, forKey: "backgroundColor")
    }
}
