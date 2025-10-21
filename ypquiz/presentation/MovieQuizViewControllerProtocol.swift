//
//  MovieQuizViewControllerProtocol.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 21.10.2025.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuizLoading()
    func hideQuizLoading()
    
    func updateQuizProgressLabel(currentQuizQuestionProgress: Int, quizziesTotal: Int)
    func updateQuizImageViewByAnswerResult(isCorrectAnswer: Bool)
    func updateButtons(enabled: Bool)
    
    func showQuizResultAlert(statisticsResult: QuizStatisticsResult)
    func showErrorAlert()
    
    func showQuizQuestion(quizQuestionViewModel: QuizQuestionViewModel)
}
