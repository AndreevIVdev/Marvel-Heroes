//
//  Character.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 01.12.2021.
//

import Foundation

struct CharactersResponse: Codable {
    let code: Int
    let status: String
    let data: DataClass
}

struct DataClass: Codable {
    let offset, limit, total, count: Int
    let characters: [mhCharacter]
    
    enum CodingKeys: String, CodingKey {
        case offset, limit, total, count
        case characters = "results"
    }
}

struct mhCharacter: Codable {
    let id: Int
    let name: String
    let description: String
    let modified: Date
    let thumbnail: Thumbnail
    let comics, series: Comics
    let stories: Stories
    let events: Comics
    let urls: [URLElement]
}

struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let returned: Int
}

struct Stories: Codable {
    let available: Int
    let collectionURI: String
    let returned: Int
}

struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case gif
    case jpg
}

struct URLElement: Codable {
    let type: String
    let url: String
}
