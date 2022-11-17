//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 12.11.2022.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    var currentQuestion: QuizQuestion?
    weak var movieQuizViewController: MovieQuizViewControllerProtocol?
    var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticService?
    var correctAnswers: Int = 0
    
    let questionsAmount = 10
    private var currentQuestionIndex = 0
    
    init(movieViewController: MovieQuizViewControllerProtocol) {
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
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
    }
    
    func makeResultsMessage() -> String {
        guard let statisticService = statisticService else {
            return "error"
        }
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        return resultMessage
        
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrect: isCorrect)
        
        movieQuizViewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
            self.movieQuizViewController?.disableImageBorder()
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
    
    func proceedToNextQuestionOrResults() {
     
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
        // заново показываем первый вопрос
        questionFactory?.requestNextQuestion()
        
    }
}
