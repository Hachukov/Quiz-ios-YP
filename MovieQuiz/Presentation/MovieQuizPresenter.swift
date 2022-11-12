//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 12.11.2022.
//

import UIKit

final class MovieQuizPresenter {
    
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
       QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
