//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 04.10.2022.
//

import UIKit

class AlertPresenter: AlertPresenterDelegate {
    
   var delegate: AlertPresenterProtocol?
    init(delegate: AlertPresenterProtocol) {
        self.delegate = delegate
    }
    
    internal func showAlert(alertModel: AlertModel) -> UIAlertController {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText,
                                   style: .cancel) {_ in
            self.delegate?.resetGame()
        }
        
        alert.addAction(action)
        return alert
    }
}



