//
//  String+Ext.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 15.10.2021.
//

import Foundation

extension String {
    enum ValidType {
        case name
        case email
        case password
    }

    enum Regex: String {
        case name = "[a-zA-Z]{1,}"
        case email = "[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\\.[A-Za-z]{2,30}"
        case password = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}"
    }

    func isValid(_ validType: ValidType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""

        switch validType {
        case .name:
            regex = Regex.name.rawValue
        case .email:
            regex = Regex.email.rawValue
        case .password:
            regex = Regex.password.rawValue
        }

        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
