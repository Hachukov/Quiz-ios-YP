//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 12.11.2022.
//

import UIKit

final class MovieQuizPresenter {
    
    var currentQuestion: QuizQuestion?
    weak var movieQuizViewComtroller: MovieQuizViewController?
    var questionFactory: QuestionFactoryProtocol?
    var correctAnswers: Int = 0
    
    let questionsAmount = 10
    private var currentQuestionIndex = 0
    
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
        movieQuizViewComtroller?.textLabel.text = model.text
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
        movieQuizViewComtroller?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.movieQuizViewComtroller?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        
        if self.isLastQuestion() {
            let text =  "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            movieQuizViewComtroller?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
