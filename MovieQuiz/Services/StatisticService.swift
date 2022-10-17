//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 17.10.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double {get}
    var gamesCount: Int {get}
    var bestGame: GameRecord {get}
}

final class StatisticServiceImplementation: StatisticService {
    var gamesCount: Int
    
    var totalAccuracy: Double = 0.0
    
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}


