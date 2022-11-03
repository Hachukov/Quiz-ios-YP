//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 01.11.2022.
//

import Foundation

//// MARK: - MostPopularMovies
//struct MostPopularMovies: Codable {
//    let errorMessage: String
//    let items: [MostPopularMovie]
//}
//
//// MARK: - MostPopularMovie
//struct MostPopularMovie: Codable {
//    let crew, fullTitle, id, imDBRating: String
//    let imDBRatingCount: String
//    let imageURL: URL
//    let rank, rankUpDown, title, year: String
//
//    enum PopularMovieKeys: String, CodingKey {
//        case crew, fullTitle, id
//        case imDBRating = "imDbRating"
//        case imDBRatingCount = "imDbRatingCount"
//        case imageURL = "image"
//        case rank, rankUpDown, title, year
//    }
//}

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        
        // создаем строку из адреса
        let urlString = imageURL.absoluteString
        
        // обрезаем лишнюю часть и добовляем модификатор желаемого качества
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        // пытаемся создать новый адрес, если не получится возврощаем старый
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
    case title = "fullTitle"
    case rating = "imDbRating"
    case imageURL = "image"
    }
} 
