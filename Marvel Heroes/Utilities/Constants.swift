//
//  Constants.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 14.10.2021.
//

import UIKit

enum Fonts {
    static let openSansRegular = "OpenSans-Regular"
    static let openSansRomanLight = "OpenSansRoman-Light"
    static let openSansRomanSemiBold = "OpenSansRoman-SemiBold"
    static let openSansBold = "OpenSansRoman-Bold"
    static let openSansRomanExtraBold = "OpenSansRoman-ExtraBold"
    static let openSansRomanCondensedRegular = "OpenSansRoman-CondensedRegular"
    static let openSansRomanCondensedLight = "OpenSansRoman-CondensedLight"
    static let openSansRomanCondensedSemiBold = "OpenSansRoman-CondensedSemiBold"
    static let openSansRomanCondensedBold = "OpenSansRoman-CondensedBold"
    static let openSansRomanCondensedExtraBold = "OpenSansRoman-CondensedExtraBold"

//    for family in UIFont.familyNames.sorted() {
//        let names = UIFont.fontNames(forFamilyName: family)
//        print("Family: \(family) Font names \(names)")
//    }
}

enum Colors {
    static let mhwhite = UIColor(rgb: 0xE5E5E5)
    static let mhRed = UIColor(rgb: 0xE91D29)
    static let mhGray = UIColor(rgb: 0xDADADA)
    static let mhLabelGray = UIColor(rgb: 0x8B999F)
}

enum FireBaseErrors {
    static let alreadyExist = "The email address is already in use by another account."
}

enum Images {
    static let placeholder = UIImage(named: "avatar-1577909_960_720")!
    static let comics = UIImage(systemName: "magazine")!
    static let series = UIImage(systemName: "film")!
    static let stories = UIImage(systemName: "text.book.closed")!
    static let events = UIImage(systemName: "calendar.badge.exclamationmark")!
    static let edited = UIImage(systemName: "pencil")!.withTintColor(Colors.mhLabelGray, renderingMode: .alwaysOriginal)
    static let isNotInFavorites = UIImage(systemName: "star")!
        .withTintColor(Colors.mhLabelGray, renderingMode: .alwaysOriginal)
    static let isInFavorites = UIImage(systemName: "star.fill")!
        .withTintColor(Colors.mhRed, renderingMode: .alwaysOriginal)
    static let emptyStateLogo = UIImage(named: "2bmdks")!
    static let emptyStar = UIImage(systemName: "star")!
    static let person = UIImage(systemName: "person")!
}

enum Keys {
    static let privateKey = "2e024a98ac4ef8a4cb81716b7ec6f2a43b0c9a0d"
    static let publicKey = "0cecba7ddefa71f1fd544125f77fc60e"
    static let baseURL = "https://gateway.marvel.com/v1/public/characters"
}
