//
//  Errors.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 17.10.2022.
//

import Foundation

enum FileManagerError: Error {
    case fileDoesntExist
}

enum ParseError: Error {
    case convertError
}
