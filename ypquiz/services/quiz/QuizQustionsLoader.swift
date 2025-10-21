//
//  QuizQustionsLoader.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 19.10.2025.
//

import Foundation
import UIKit

struct QuizQustionsLoader: QuizQuestionsLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkClientProtocol
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - QuizQuestionsLoading
    func loadQuizQuestions(handler: @escaping (Result<QuizQuestions, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    let shuffledMovies = Array(mostPopularMovies.items.shuffled().prefix(10))
                    let questions = shuffledMovies.map(MostPopularMovieMapper.map(movie:))
                    
                    handler(.success(QuizQuestions(questions: questions)))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
