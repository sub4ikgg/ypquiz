//
//  QuizQuestionsDelegate.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 18.10.2025.
//

import Foundation

protocol QuizQuestionsDelegate: AnyObject {
    func didFinishQuiz()
    func didReceiveNewQuizQuestion(quizQuestion: QuizQuestion)
}
