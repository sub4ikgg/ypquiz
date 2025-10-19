//
//  MockQuizQuestions.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 17.10.2025.
//

import Foundation
import UIKit

struct MockQuizQuestions {
    static func fetch() -> [QuizQuestion] {
        return [
            QuizQuestion(
                image: UIImage(named: "AlienPoster")!,
                question: "Рейтинг этого фильма меньше 5?",
                answer: false
            ),
            QuizQuestion(
                image: UIImage(named: "InceptionPoster")!,
                question: "Рейтинг этого фильма меньше 6?",
                answer: false
            ),
            QuizQuestion(
                image: UIImage(named: "InterstellarPoster")!,
                question: "Рейтинг этого фильма меньше 7?",
                answer: false
            ),
            QuizQuestion(
                image: UIImage(named: "MatrixPoster")!,
                question: "Рейтинг этого фильма больше 9?",
                answer: false
            ),
            QuizQuestion(
                image: UIImage(named: "AvatarPoster")!,
                question: "Рейтинг этого фильма меньше 8?",
                answer: true
            ),
            QuizQuestion(
                image: UIImage(named: "TitanicPoster")!,
                question: "Рейтинг этого фильма больше 8?",
                answer: true
            ),
            QuizQuestion(
                image: UIImage(named: "JokerPoster")!,
                question: "Рейтинг этого фильма меньше 7?",
                answer: false
            ),
            QuizQuestion(
                image: UIImage(named: "GodfatherPoster")!,
                question: "Рейтинг этого фильма больше 9?",
                answer: true
            ),
            QuizQuestion(
                image: UIImage(named: "StarWarsPoster")!,
                question: "Рейтинг этого фильма меньше 6?",
                answer: false
            ),
            QuizQuestion(
                image: UIImage(named: "LordOfTheRingsPoster")!,
                question: "Рейтинг этого фильма больше 9?",
                answer: true
            ),
        ].shuffled()
    }
}
