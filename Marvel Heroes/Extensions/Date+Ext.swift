//
//  Date+Ext.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 02.01.2022.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
}
