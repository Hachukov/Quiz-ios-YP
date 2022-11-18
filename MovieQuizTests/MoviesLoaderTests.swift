//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Arsen Hachuk on 09.11.2022.
//

import XCTest

@testable import MovieQuiz // Импортируем приложение для тестирование

class MoviesLoadetTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        // emulateError: false значит что ошибка эмулироватся не будет
        let stabNetworkClient = StabNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stabNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
                
            case .success(let movies):
                // слвыниваем данныем с ожидаемыми
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                // нет ожидание ошибки
                XCTFail("Unexpected failure") // эта функция проваЛивает тест
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        // Given
        //  emulateError: true значит что ошибка будет эмулироваться
        let stabNetworkClient = StabNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stabNetworkClient)
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
                
            case .success(_):
                XCTFail("Unexpected failure")
                
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
                
            }
        }
        waitForExpectations(timeout: 1)
    }
}


// MARK: - STAB for tests

struct StabNetworkClient: NetworkRoutingProtocol {
    enum TestError: Error {
        case test
    }
    
    let emulateError: Bool
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            handler(.success(expectedResponse))
        }
    }
    
    private var expectedResponse: Data {
            """
            {
               "errorMessage" : "",
               "items" : [
                  {
                     "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
                     "fullTitle" : "Prey (2022)",
                     "id" : "tt11866324",
                     "imDbRating" : "7.2",
                     "imDbRatingCount" : "93332",
                     "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
                     "rank" : "1",
                     "rankUpDown" : "+23",
                     "title" : "Prey",
                     "year" : "2022"
                  },
                  {
                     "crew" : "Anthony Russo (dir.), Ryan Gosling, Chris Evans",
                     "fullTitle" : "The Gray Man (2022)",
                     "id" : "tt1649418",
                     "imDbRating" : "6.5",
                     "imDbRatingCount" : "132890",
                     "image" : "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg",
                     "rank" : "2",
                     "rankUpDown" : "-1",
                     "title" : "The Gray Man",
                     "year" : "2022"
                  }
                ]
              }
            """.data(using: .utf8) ?? Data()
    }
}
