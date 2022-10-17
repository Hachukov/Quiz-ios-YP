//
//  AlertDelegate.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 09.10.2022.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alertModel: AlertModel) -> UIAlertController
}
