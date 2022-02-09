//
//  DetailedInformationViewModel.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 03.01.2022.
//

import Foundation

struct DetailedInformationViewModel {
    let avatarURL: URL?
    let name: String
    let id: Int
    let modified: Date
    let description: String
    let comicsCount: Int
    let seriesCount: Int
    let storiesCount: Int
    let eventsCount: Int
    let comicsURL: URL?
    let storiesURL: URL?
}
