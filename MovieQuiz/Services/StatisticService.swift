//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 17.10.2022.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double {get}
    var gamesCount: Int {get set}
    var bestGame: GameRecord {get}
}

final class StatisticServiceImplementation: StatisticService {

    private var userDefaults = UserDefaults.standard
 
    private enum Keys: String {
        case correct, totalAccuracy, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        if bestGame.correct < count {
            bestGame.correct = count
            bestGame.date = Date()
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
                print("Не возможно сохранить результат")
                return
                
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalAccuracy.rawValue),
                  let total = try? JSONDecoder().decode(Double.self, from: data)  else {
                return 0.0
            }
            return total
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Не возможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.totalAccuracy.rawValue)
        }
    }
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
                print("Результат не может быть сохранен")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
}

struct GameRecord: Codable {
    var correct: Int
    let total: Int
    var date: Date

}
