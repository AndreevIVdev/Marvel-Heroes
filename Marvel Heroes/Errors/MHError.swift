//
//  MHError.swift
//  Marvel Heroes
//
//  Created by Илья Андреев on 08.02.2022.
//

import Foundation

public enum mhError: String, Error {

    case invalidURL = "This string creates invalid URL, try another one."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case dataBaseError = "Something went wrong with db. Pls try again."
    case alreadyInFavorites = "Something went wrong. This character is already in favorites."
    case isNotInFavorites = "Something went wrong. This character isn't in favorites."
    case favoritingError = "Something went wrong with favoriting. Please try again."
    case userHasNoEmail = "User has no email!"
    case unableToRemoveCellInTableView = "Something went wrong with editing(deleting)"
    case noComics = "This character has no comics."
    case noWiki = "No wiki page available for this character!"
}
