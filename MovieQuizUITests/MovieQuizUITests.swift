//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Arsen Hachuk on 10.11.2022.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        
        // Эта настройкак прерывает тестирование если один тест не проше
        // возможно это нужно для экономии времени
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButton() {
        let firstPoster = app.images["Poster"] // находим первоначальный постер
    
        app.buttons["Yes"].tap() // находим кнопку Да и нажмем ее

        let secondPoster = app.images["Poster"] // еще раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        XCTAssertFalse(firstPoster == secondPoster)// проверяем, что почтеры разные
        
        XCTAssertTrue(indexLabel.label == "2/10")
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["No"].tap() // находим кнопку Да и нажмем ее
        
        let secondPoster = app.images["Poster"] // еще раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        XCTAssertFalse(firstPoster == secondPoster)// проверяем, что почтеры разные
        
        XCTAssertTrue(indexLabel.label == "2/10")
    }
    
    func testGameFinish() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }
        
        sleep(2)
        
        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }

    func testAlertDismiss() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }
        
        sleep(2)
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
}
