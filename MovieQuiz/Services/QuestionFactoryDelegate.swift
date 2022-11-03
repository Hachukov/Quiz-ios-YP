//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 04.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()// сообщение об успешной загрузки
    func didFailToLoadData(with error: Error) // Сообщение об ошибке
}
