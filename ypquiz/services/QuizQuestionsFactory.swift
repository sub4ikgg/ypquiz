//
//  QuizQuestionsFactory.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 18.10.2025.
//

import Foundation

final class QuizQuestionsFactory: QuizQuestionsFactoryProtocol {
    private let quizQuestionsLoader: QuizQuestionsLoading
    
    private var quizQuestions = [QuizQuestion]()
    
    weak var delegate: QuizQuestionsDelegate?
    
    init(quizQuestionsLoader: QuizQuestionsLoading = QuizQustionsLoader()) {
        self.quizQuestionsLoader = quizQuestionsLoader
    }
    
    func setupDelegate(_ delegate: (any QuizQuestionsDelegate)?) {
        self.delegate = delegate
    }
    
    func loadQuizQuestions() {
        quizQuestionsLoader.loadQuizQuestions { result in
            switch result {
            case .success(let quizQuestions):
                self.quizQuestions = quizQuestions.questions
                self.delegate?.didLoadedQuestions(count: self.quizQuestions.count)
                self.requestNextQuizQuestion()
                
            case .failure(let error):
                self.delegate?.didReceiveError(error: error)
            }
        }
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
