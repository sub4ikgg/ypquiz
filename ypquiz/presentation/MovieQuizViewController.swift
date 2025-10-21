//
//  MovieQuizViewController.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 17.10.2025.
//

import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private weak var quizProgressLabel: UILabel!
    @IBOutlet private weak var quizQuestionLabel: UILabel!
    @IBOutlet private weak var quizImageView: UIImageView!
    
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let presenter = MovieQuizPresenter()
    private let quizAlertPresenter = QuizAlertPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setupViewController(self)
        presenter.startQuiz()
        
        activityIndicator.isAccessibilityElement = true
        activityIndicator.accessibilityIdentifier = "activityIndicator"
    }
    
    // MARK: - Quiz Flow
    func showQuizQuestion(quizQuestionViewModel: QuizQuestionViewModel) {
        updateQuizImageView(image: quizQuestionViewModel.image)
        updateQuizQuestionLabel(question: quizQuestionViewModel.question)
        updateButtons(enabled: true)
        
        if activityIndicator.isAnimating {
            hideQuizLoading()
        }
    }
    
    func showQuizResultAlert(statisticsResult: QuizStatisticsResult) {
        let message = """
            Ваш результат: \(statisticsResult.score)/\(statisticsResult.total)
            Количество сыгранных квизов: \(statisticsResult.quizzesPlayed)
            Рекорд: \(statisticsResult.record)
            Средняя точность: \(String(format: "%.2f", statisticsResult.averageAccuracy))%
        """
        
        quizAlertPresenter.show(
            in: self,
            model: QuizAlertModel(
                title: QuizResultConstants.alertTitle,
                message: message,
                buttonText: QuizResultConstants.playAgainActionTitle,
                completion: { [weak self] in
                    self?.presenter.startQuiz()
                }
            )
        )
    }
    
    func showErrorAlert() {
        quizAlertPresenter.show(
            in: self,
            model: QuizAlertModel(
                title: QuizErrorConstants.alertTitle,
                message: QuizErrorConstants.alertMessage,
                buttonText: QuizErrorConstants.buttonText,
                completion: { [weak self] in
                    self?.presenter.startQuiz()
                }
            )
        )
    }
    
    // MARK: - UI Updates
    func updateQuizProgressLabel(currentQuizQuestionProgress: Int, quizziesTotal: Int) {
        quizProgressLabel.text = "\(currentQuizQuestionProgress)/\(quizziesTotal)"
    }
    
    func updateQuizImageView(image: UIImage) {
        quizImageView.image = image
        quizImageView.layer.borderWidth = 0
    }
    
    func updateQuizQuestionLabel(question: String) {
        quizQuestionLabel.text = question
    }
    
    func updateButtons(enabled: Bool) {
        noButton.isUserInteractionEnabled = enabled
        yesButton.isUserInteractionEnabled = enabled
    }
    
    func updateQuizImageViewByAnswerResult(isCorrectAnswer: Bool) {
        quizImageView.layer.masksToBounds = true
        quizImageView.layer.borderWidth = 8
        quizImageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        quizImageView.layer.cornerRadius = 20
    }
    
    func showQuizLoading() {
        if activityIndicator.isAnimating { return }
        
        quizImageView.setVisibility(false)
        quizQuestionLabel.setVisibility(false)
        buttonsStackView.setVisibility(false)
        
        activityIndicator.setVisibility(true)
        activityIndicator.startAnimating()
    }
    
    func hideQuizLoading() {
        if !activityIndicator.isAnimating { return }
        
        activityIndicator.setVisibility(false)
        activityIndicator.stopAnimating()
        
        quizImageView.setVisibility(true)
        quizQuestionLabel.setVisibility(true)
        buttonsStackView.setVisibility(true)
    }
    
    // MARK: - Actions
    @IBAction func noButtonTouch(_ sender: Any) {
        presenter.noButtonTouch(sender)
    }
    
    @IBAction func yesButtonTouch(_ sender: Any) {
        presenter.yesButtonTouch(sender)
    }
}

