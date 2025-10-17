//
//  ViewController.swift
//  ypquiz
//
//  Created by Кирилл Ефремов on 17.10.2025.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var quizProgressLabel: UILabel!
    @IBOutlet private weak var quizQuestionLabel: UILabel!
    @IBOutlet private weak var quizImageView: UIImageView!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var quizQuestions: [QuizQuestion] = []
    private var currentQuizQuestionIndex = 0
    
    private var score = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startQuiz()
    }
    
    // MARK: - Quiz Flow
    private func startQuiz() {
        quizQuestions = fetchQuizQuestions()
        currentQuizQuestionIndex = 0
        
        score = 0
        
        updateQuizProgressLabel()
        updateQuizImageView()
        updateQuizQuestionLabel()
        updateButtons(enabled: true)
    }
    
    private func continueQuiz() {
        currentQuizQuestionIndex += 1
        
        updateQuizProgressLabel()
        updateQuizImageView()
        updateQuizQuestionLabel()
        updateButtons(enabled: true)
    }
    
    private func showQuizResultAlert() {
        let defaults = UserDefaults.standard
        let total = quizQuestions.count
        
        let currentAccuracy = (Double(score) / Double(total)) * 100
        
        let quizzesPlayed = defaults.integer(forKey: "quizzes_played")
        let previousAverage = defaults.double(forKey: "average_accuracy")
        let record = defaults.integer(forKey: "record")
        let recordDate = (defaults.object(forKey: "record_date") as? Date) ?? Date()
        
        let newAverageAccuracy = (previousAverage * Double(quizzesPlayed) + currentAccuracy) / Double(quizzesPlayed + 1)
        
        let isNewRecord = score > record
        if isNewRecord {
            saveRecord()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let formattedDate = dateFormatter.string(from: recordDate)
        
        let message = """
            Ваш результат: \(score)/\(total)
            Количество сыгранных квизов: \(quizzesPlayed)
            Рекорд: \(isNewRecord ? score : record)/\(total) (\(formattedDate))
            Средняя точность: \(String(format: "%.2f", newAverageAccuracy))%
        """
        
        let alertController = UIAlertController(
            title: "Этот раунд окончен!",
            message: message,
            preferredStyle: .alert
        )
        
        let playAgainAction = UIAlertAction(title: "Сыграть еще раз", style: .default) { [weak self] _ in
            self?.startQuiz()
        }
        
        alertController.addAction(playAgainAction)
        present(alertController, animated: true)
        
        saveQuizzesPlayed(quizzesPlayed: quizzesPlayed + 1)
        saveAverageAccuracy(averageAccuracy: newAverageAccuracy)
    }

    
    private func answerQuiz(answer: Bool) {
        let isCorrectAnswer = quizQuestions[currentQuizQuestionIndex].answer == answer
        
        if (isCorrectAnswer) {
            score += 1
        }
        
        quizImageView.layer.masksToBounds = true
        quizImageView.layer.borderWidth = 8
        quizImageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        quizImageView.layer.cornerRadius = 20
        
        updateButtons(enabled: false)
        
        if ((currentQuizQuestionIndex + 1) < quizQuestions.count) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.continueQuiz()
            }
        } else {
            showQuizResultAlert()
        }
    }
    
    // MARK: - UI Updates
    private func updateQuizProgressLabel() {
        quizProgressLabel.text = "\(currentQuizQuestionIndex + 1)/\(quizQuestions.count)"
    }
    
    private func updateQuizImageView() {
        quizImageView.image = quizQuestions[currentQuizQuestionIndex].image
        quizImageView.layer.borderWidth = 0
    }
    
    private func updateQuizQuestionLabel() {
        quizQuestionLabel.text = quizQuestions[currentQuizQuestionIndex].question
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
    
    // MARK: - Util
    private func fetchQuizQuestions() -> [QuizQuestion] {
        return MockQuizQuestions.fetch()
    }
    
    private func saveRecord() {
        UserDefaults.standard.set(score, forKey: "record")
        UserDefaults.standard.set(Date(), forKey: "record_date")
    }
    
    private func saveQuizzesPlayed(quizzesPlayed: Int) {
        UserDefaults.standard.set(quizzesPlayed, forKey: "quizzes_played")
    }
    
    private func saveAverageAccuracy(averageAccuracy: Double) {
        UserDefaults.standard.set(averageAccuracy, forKey: "average_accuracy")
    }
}

