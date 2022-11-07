//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 03.10.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoadingProtocol
    weak var delegate: QuestionFactoryDelegate?
    weak var alertPresenterProtocol: AlertPresenterProtocol?
    private let randomQuestion = Bool.random()
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
                print("Failed to load image")
                
            }
            
            let rating = Float(movie.rating) ?? 0

           // Генерация текста вопроса
            if self.randomQuestion {
                self.questionText = "Рейтинг этого фильма больше чем \(String(format: "%.1f", rating + 1)) ?"
            } else {
                self.questionText = "Рейтинг этого фильма меньше чем \(String(format: "%.1f", rating - 1))?"
            }
            let text = self.questionText
            let correctAnswer = rating > 7
            
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
