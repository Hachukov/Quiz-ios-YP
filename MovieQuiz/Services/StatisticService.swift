//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 17.10.2022.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get }
    var allTimeQuestions: Int { get set }
    var allTimeCorrectAnswers: Int { get set }
}

final class StatisticServiceImplementation: StatisticService {
    
    private var userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, totalAccuracy, bestGame, gamesCount, allTimeQuestions, allTimeCorrectAnswers
    }
    
    func store(correct count: Int, total amount: Int) {
        let curentGame = GameRecord(correct: count, total: amount)
        if bestGame < curentGame {
            bestGame = curentGame
        }
        totalAccuracy = Double(allTimeCorrectAnswers) / Double(allTimeQuestions) * 100
    }
    
    var allTimeQuestions: Int {
        get {
//            let questions = userDefaults.integer(forKey: Keys.allTimeQuestions.rawValue)
//            return questions
            guard let data = userDefaults.data(forKey: Keys.allTimeQuestions.rawValue),
                    let questions = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return questions
        }
        set {
//            let questions = Int()
//            userDefaults.set(questions, forKey: Keys.allTimeQuestions.rawValue)
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Не возможно сохранить questions")
                      return
            }
            userDefaults.set(data, forKey: Keys.allTimeQuestions.rawValue)
        }
    }
    
    var allTimeCorrectAnswers: Int {
        get {
//            let correctAnswers = userDefaults.integer(forKey: Keys.allTimeCorrectAnswers.rawValue)
//            return correctAnswers
            guard let data = userDefaults.data(forKey: Keys.allTimeCorrectAnswers.rawValue),
                    let answers = try? JSONDecoder().decode(Int.self, from: data) else  {
                return 0
            }
            return answers
        }
        set {
//            let correctAnswers = Int()
//            userDefaults.set(correctAnswers, forKey: Keys.allTimeCorrectAnswers.rawValue)
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Не возможно сохранить correctAnswers")
                return
            }
            userDefaults.set(data, forKey: Keys.allTimeCorrectAnswers.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            //возврощаем значения game count
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let gameCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return gameCount
            
        }
        set {
            // Сохраняем новое значение для games count
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Не возможно сохранить результат gamesCount")
                return
                
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var totalAccuracy = Double()

    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data  = try? JSONEncoder().encode(newValue) else {
                print("Результат bestGame  не может быть сохранен")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
}

struct GameRecord: Codable {
    var correct: Int
    let total: Int
    var date = Date()
    
}

// расширения Comparable дает возможность сравнивать
extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    
}
