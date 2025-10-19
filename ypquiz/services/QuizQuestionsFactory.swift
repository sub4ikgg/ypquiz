//
//  QuizQuestionsFactory.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 18.10.2025.
//

import Foundation

final class QuizQuestionsFactory: QuizQuestionsFactoryProtocol {
    weak var delegate: QuizQuestionsDelegate?
    
    private var quizQuestions = [QuizQuestion]()
    
    private func fetchQuestions() -> [QuizQuestion] {
        MockQuizQuestions.fetch()
    }
    
    func setupDelegate(_ delegate: (any QuizQuestionsDelegate)?) {
        self.delegate = delegate
    }
    
    func requestQuizQuestions() -> Int {
        quizQuestions = fetchQuestions()
        return quizQuestions.count
    }

    func requestNextQuizQuestion() {
        if quizQuestions.isEmpty {
            delegate?.didFinishQuiz()
            return
        }
        
        let quizQuestion = quizQuestions.removeFirst()
        delegate?.didReceiveNewQuizQuestion(quizQuestion: quizQuestion)
    }
}
