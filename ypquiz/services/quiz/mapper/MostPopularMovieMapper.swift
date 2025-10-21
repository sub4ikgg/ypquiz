//
//  MostPopularMovieMapper.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 19.10.2025.
//

import Foundation

final class MostPopularMovieMapper {
    static func map(movie: MostPopularMovie) -> QuizQuestion {
        let imageData = try? Data(contentsOf: movie.resizedImageURL)
        
        let rating = Double(movie.rating) ?? 0.0
        let questionRating = Double(Int.random(in: 6...9))
        
        let isMore = Bool.random()
        let answer = isMore ? (rating > questionRating) : (rating < questionRating)
        
        let questionComparisonDirection = isMore ? "больше" : "меньше"
        let question = "Рейтинг этого фильма \(questionComparisonDirection) \(Int(questionRating))?"
        
        return QuizQuestion(
            imageData: imageData ?? Data(),
            question: question,
            answer: answer
        )
    }
}
