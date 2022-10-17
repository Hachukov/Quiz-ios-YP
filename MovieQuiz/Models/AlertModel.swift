//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 04.10.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var comletion: (() -> Void)?
}
