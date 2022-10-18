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
    var gamesCount: Int {get}
    var bestGame: GameRecord {get}
}

final class StatisticServiceImplementation: StatisticService {

    private var userDefaults = UserDefaults.standard
 
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        <#code#>
    }
    
   
    var gamesCount: Int = 0
    var totalAccuracy: Double = 0.0
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
    let correct: Int
    let total: Int
    let date: Date
}
