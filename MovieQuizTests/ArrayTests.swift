//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Arsen Hachuk on 09.11.2022.
//

import XCTest
@testable import MovieQuiz // Импортируем приложение для тестирование

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        // Given
        let array = [1,1,2,3,5]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1,2,3,4,5]
        // When
        let value = array[safe: 20]
        // Then
        XCTAssertNil(value)
    }
}

