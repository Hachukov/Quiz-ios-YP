//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 03.10.2022.
//

import Foundation
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoadingProtocol
    weak var delegate: QuestionFactoryDelegate?
    private var randomQuestion = Bool.random()
    private var questionText = ""
    
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохранения фильма в переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
        }
    }
    
    func requestNextQuestion(){
            
        // запускаем выполнение функции в другом потоке
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            // попытка создание данных из URL
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
             // TODO: - сделать алерт для ошибки
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: error)
                }
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            var correctAnswer = true
           // Генерация текста вопроса
            correctAnswer = rating > 8.5
            self.questionText = "Рейтинг этого фильма больше чем 8.5 ?"
            let text = self.questionText
         
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
}
