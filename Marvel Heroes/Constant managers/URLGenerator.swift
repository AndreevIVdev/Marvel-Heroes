//
//  ApiKeysManager.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 02.12.2021.
//

import Foundation

protocol URLGeneratorable: AnyObject {
    func getAllCharactersURL(withOffset: Int) -> URL?
    func getAvatarURL(path: String, ext: String) -> URL?
    func getCharacterURLbyID(id: Int) -> URL?
    func makeUrlWithValidKey(from: String) -> URL?
}

final class URLGenerator: URLGeneratorable {
   
    private var privateKey: String
    private var publicKey: String
    private let baseURL: String
    private var hasher: (String) -> (String)
    private var timestamp: String
    
    private var hash: String {
        hasher(timestamp + privateKey + publicKey)
    }
    
    init(privateKey: String, publicKey: String, baseURL: String, hasher: @escaping (String) -> (String)) {
        self.baseURL = baseURL
        self.privateKey = privateKey
        self.publicKey = publicKey
        self.hasher = hasher
        timestamp = String(NSDate().timeIntervalSince1970)
    }
    
    func getAllCharactersURL(withOffset: Int = 0) -> URL? {
        URL(
            string:
                baseURL + "?" + "offset=\(withOffset)" + "&ts=" + timestamp + "&apikey=" + publicKey + "&hash=" + hash
        )
    }
    
    func getAvatarURL(path: String, ext: String) -> URL? {
        URL(string: path + "." + ext)
    }
    
    func getCharacterURLbyID(id: Int) -> URL? {
        URL(
            string: baseURL + "/\(id)" + "?" + "&ts=" + timestamp + "&apikey=" + publicKey + "&hash=" + hash
        )
    }
    
    func makeUrlWithValidKey(from: String) -> URL? {
        URL(
            string:
                from + "?" + "&ts=" + timestamp + "&apikey=" + publicKey + "&hash=" + hash
        )
    }
}
