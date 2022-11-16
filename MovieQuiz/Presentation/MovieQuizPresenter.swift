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
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        movieQuizViewComtroller?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButton() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        movieQuizViewComtroller?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
}
