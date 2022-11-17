//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 12.11.2022.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    var currentQuestion: QuizQuestion?
    weak var movieQuizViewController: MovieQuizViewController?
    var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticService?
    var correctAnswers: Int = 0
    
    let questionsAmount = 10
    private var currentQuestionIndex = 0
    
    init(movieViewController: MovieQuizViewController) {
        self.movieQuizViewController = movieViewController
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        movieViewController.showLoadingIndicator()
    }

    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        movieQuizViewController?.textLabel.text = model.text
        return  QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                  question: model.text,
                                  questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButton() {
        didAnswer(isYes: true)
    }
    
    func noButton() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        movieQuizViewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didAnswer(isCorrect: Bool) {
        if isCorrect {
            movieQuizViewController?.imageView.layer.borderColor = UIColor.YPGreen.cgColor// цвет рамки
            correctAnswers += 1
            print(correctAnswers)
        } else {
            movieQuizViewController?.imageView.layer.borderColor = UIColor.YPRed.cgColor // цвет рамки
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        movieQuizViewController?.showNetworkError(message: message)
    }
    
    func didLoadDataFromServer() {
        movieQuizViewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.movieQuizViewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
     
        if self.isLastQuestion() {
            let text =  "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            movieQuizViewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    func resetGame() {
        //Обнуляем счетчик вопросов
        resetQuestionIndex()
        // Обнуляем счетчик правельных ответов
        correctAnswers = 0
            movieQuizViewController?.counterLabel.text = "\(correctAnswers)/\(questionsAmount)"
        // заново показываем первый вопрос
        questionFactory?.requestNextQuestion()
        
    }
}
