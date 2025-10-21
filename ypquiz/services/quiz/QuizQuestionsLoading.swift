//
//  QuizQuestionsLoading.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 19.10.2025.
//

import Foundation
import UIKit

protocol QuizQuestionsLoading {
    func loadQuizQuestions(handler: @escaping (Result<QuizQuestions, Error>) -> Void)
}
