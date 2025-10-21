//
//  QuizQuestionsFactoryProtocol.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 18.10.2025.
//

import Foundation

protocol QuizQuestionsFactoryProtocol {
    var delegate: QuizQuestionsDelegate? { set get }
    
    func setupDelegate(_ delegate: QuizQuestionsDelegate?)
    
    func loadQuizQuestions()
    func requestNextQuizQuestion()
}
