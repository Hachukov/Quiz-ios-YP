//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Arsen Hachuk on 31.10.2022.
//

import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRoutingProtocol {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверка на ошибку
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Проверяем что нам пришел успешний код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // возврощаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
