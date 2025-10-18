//
//  MovieQuizViewController.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 17.10.2025.
//

import UIKit

final class MovieQuizViewController: UIViewController, QuizQuestionsDelegate {
    private let quizQuestionsFactory: QuizQuestionsFactoryProtocol
    private let quizStatisticsService: QuizStatisticsServiceProtocol
    
    @IBOutlet private weak var quizProgressLabel: UILabel!
    @IBOutlet private weak var quizQuestionLabel: UILabel!
    @IBOutlet private weak var quizImageView: UIImageView!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private let quizResultAlertPresenter = QuizResultAlertPresenter()
    
    private var score = 0
    private var currentQuizQuestion: QuizQuestion? = nil
    private var currentQuizQuestionProgress = 0
    private var quizziesTotal = 0
    
    required init?(coder: NSCoder) {
        self.quizQuestionsFactory = QuizQuestionsFactory()
        self.quizStatisticsService = QuizStatisticsService()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quizQuestionsFactory.setupDelegate(self)
        
        startQuiz()
    }
    
    // MARK: - Quiz Flow
    private func startQuiz() {
        currentQuizQuestion = nil
        currentQuizQuestionProgress = 0
        score = 0
        
        quizziesTotal = quizQuestionsFactory.requestQuizQuestions()
        quizQuestionsFactory.requestNextQuizQuestion()
    }
    
    private func showQuizQuestion(quizQuestion: QuizQuestion) {
        currentQuizQuestion = quizQuestion
        currentQuizQuestionProgress = currentQuizQuestionProgress + 1
        
        updateQuizProgressLabel(currentQuizQuestionProgress: currentQuizQuestionProgress, quizziesTotal: quizziesTotal)
        updateQuizImageView(image: quizQuestion.image)
        updateQuizQuestionLabel(question: quizQuestion.question)
        updateButtons(enabled: true)
    }
    
    private func showQuizResultAlert() {
        let statistics = QuizStatistics(score: score, total: quizziesTotal)
        let statisticsResult = quizStatisticsService.processStatistics(quizStatistics: statistics)
        
        let message = """
            Ваш результат: \(statisticsResult.score)/\(statisticsResult.total)
            Количество сыгранных квизов: \(statisticsResult.quizzesPlayed)
            Рекорд: \(statisticsResult.record)
            Средняя точность: \(String(format: "%.2f", statisticsResult.averageAccuracy))%
        """
        
        quizResultAlertPresenter.show(
            in: self,
            model: QuizResultModel(
                title: QuizResultConstants.alertTitle,
                message: message,
                buttonText: QuizResultConstants.playAgainActionTitle,
                completion: { [weak self] in
                    self?.startQuiz()
                }
            )
        )
    }
    
    private func answerQuiz(answer: Bool) {
        guard let currentQuizQuestion = currentQuizQuestion else { return }
        let isCorrectAnswer = currentQuizQuestion.answer == answer
        
        if isCorrectAnswer {
            score += 1
        }
        
        quizImageView.layer.masksToBounds = true
        quizImageView.layer.borderWidth = 8
        quizImageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        quizImageView.layer.cornerRadius = 20
        
        updateButtons(enabled: false)
        
        let isLastQuizQuestion = currentQuizQuestionProgress == quizziesTotal
        DispatchQueue.main.asyncAfter(deadline: .now() + (isLastQuizQuestion ? 0 : 1)) { [weak self] in
            guard let self = self else { return }
            
            self.quizQuestionsFactory.requestNextQuizQuestion()
        }
    }
    
    // MARK: - UI Updates
    private func updateQuizProgressLabel(currentQuizQuestionProgress: Int, quizziesTotal: Int) {
        quizProgressLabel.text = "\(currentQuizQuestionProgress)/\(quizziesTotal)"
    }
    
    private func updateQuizImageView(image: UIImage) {
        quizImageView.image = image
        quizImageView.layer.borderWidth = 0
    }
    
    private func updateQuizQuestionLabel(question: String) {
        quizQuestionLabel.text = question
    }
    
    private func updateButtons(enabled: Bool) {
        noButton.isUserInteractionEnabled = enabled
        yesButton.isUserInteractionEnabled = enabled
    }
    
    // MARK: - Actions
    @IBAction func noButtonTouch(_ sender: Any) {
        answerQuiz(answer: false)
    }
    
    @IBAction func yesButtonTouch(_ sender: Any) {
        answerQuiz(answer: true)
    }
    
    // MARK: - QuizQuestionsDelegate
    internal func didFinishQuiz() {
        showQuizResultAlert()
    }
    
    internal func didReceiveNewQuizQuestion(quizQuestion: QuizQuestion) {
        showQuizQuestion(quizQuestion: quizQuestion)
    }
}

