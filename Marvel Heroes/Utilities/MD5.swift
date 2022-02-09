//
//  MD5.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 01.12.2021.
//

import Foundation
import CryptoKit

func MD5(string: String) -> String {
    Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        .map {
            String(format: "%02hhx", $0)
        }
        .joined()
}
