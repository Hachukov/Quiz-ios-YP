//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 01.11.2022.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoadingProtocol {
    
    // MARK: - NetworkClient
    private let networkClient: NetworkRoutingProtocol
    
    init(networkClient: NetworkRoutingProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_p2ru0lcx") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch {
                    handler(.failure(error))
                }
                
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
