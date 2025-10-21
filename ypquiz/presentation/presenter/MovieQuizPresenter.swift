//
//  MovieQuizPresenter.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 21.10.2025.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuizQuestionsDelegate {
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    private let quizQuestionsFactory: QuizQuestionsFactoryProtocol
    private let quizStatisticsService: QuizStatisticsServiceProtocol
    
    private var score = 0
    private var currentQuizQuestion: QuizQuestion? = nil
    private var currentQuizQuestionProgress = 0
    private var quizziesTotal = 0
    
    private var isQuizLoading = false
    
    init(
        quizQuestionsFactory: QuizQuestionsFactoryProtocol = QuizQuestionsFactory(),
        quizStatisticsService: QuizStatisticsServiceProtocol = QuizStatisticsService()
    ) {
        self.quizQuestionsFactory = quizQuestionsFactory
        self.quizStatisticsService = quizStatisticsService
    }
    
    func setupViewController(_ vc: MovieQuizViewControllerProtocol) {
        viewController = vc
        self.quizQuestionsFactory.setupDelegate(self)
    }
    
    func convert(quizQuestion: QuizQuestion) -> QuizQuestionViewModel? {
        guard let image = UIImage(data: quizQuestion.imageData) else { return nil }
        
        return QuizQuestionViewModel(
            image: image,
            question: quizQuestion.question,
            answer: quizQuestion.answer
        )
    }
    
    func startQuiz() {
        viewController?.showQuizLoading()
        quizQuestionsFactory.loadQuizQuestions()
    }
    
    private func processQuizAnswer(answer: Bool) {
        guard let currentQuizQuestion else { viewController?.showErrorAlert(); return }
        let isCorrectAnswer = currentQuizQuestion.answer == answer
        
        if isCorrectAnswer {
            score += 1
        }
        
        viewController?.updateQuizImageViewByAnswerResult(isCorrectAnswer: isCorrectAnswer)
        viewController?.updateButtons(enabled: false)
        
        let isLastQuizQuestion = currentQuizQuestionProgress == quizziesTotal
        DispatchQueue.main.asyncAfter(deadline: .now() + (isLastQuizQuestion ? 0 : 1)) { [weak self] in
            guard let self else { return }
            
            self.quizQuestionsFactory.requestNextQuizQuestion()
        }
    }
    
    // MARK: - Actions
    func noButtonTouch(_ sender: Any) {
        processQuizAnswer(answer: false)
    }
    
    func yesButtonTouch(_ sender: Any) {
        processQuizAnswer(answer: true)
    }
    
    // MARK: - QuizQuestionsDelegate
    internal func didFinishQuiz() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let statistics = QuizStatistics(score: score, total: quizziesTotal)
            let statisticsResult = quizStatisticsService.processStatistics(quizStatistics: statistics)
            
            self.viewController?.showQuizResultAlert(statisticsResult: statisticsResult)
        }
    }

    internal func didLoadedQuestions(count: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            viewController?.hideQuizLoading()

            score = 0
            currentQuizQuestionProgress = 0
            quizziesTotal = count
            
            self.viewController?.updateQuizProgressLabel(
                currentQuizQuestionProgress: 1,
                quizziesTotal: quizziesTotal
            )
        }
    }
    
    internal func didReceiveNewQuizQuestion(quizQuestion: QuizQuestion) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            currentQuizQuestion = quizQuestion
            currentQuizQuestionProgress += 1
            
            self.viewController?.updateQuizProgressLabel(
                currentQuizQuestionProgress: currentQuizQuestionProgress,
                quizziesTotal: quizziesTotal
            )
            
            guard let viewModel = convert(quizQuestion: quizQuestion) else { viewController?.showErrorAlert(); return }
            viewController?.showQuizQuestion(quizQuestionViewModel: viewModel)
        }
    }
    
    internal func didReceiveError(error: any Error) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showErrorAlert()
        }
    }
}
