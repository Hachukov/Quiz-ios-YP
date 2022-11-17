//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Arsen Hachuk on 17.11.2022.
//

import XCTest

@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func disableImageBorder() {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
    }

    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
}


final class MovieQuizPresenterTests: XCTestCase {
    let movieViewControllerMock = MovieQuizViewControllerProtocolMock()
    func testPresenterConvertModel() throws {
        
        let sut = MovieQuizPresenter(movieViewController: movieViewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
