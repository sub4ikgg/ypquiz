//
//  MovieQuizPresenterTests.swift
//  ypquizTests
//
//  Created by Кирилл Ефремов on 21.10.2025.
//

import Foundation
import XCTest

@testable import ypquiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showQuizLoading() {}
    
    func hideQuizLoading() {}
    
    func updateQuizProgressLabel(currentQuizQuestionProgress: Int, quizziesTotal: Int) {}
    
    func updateQuizImageViewByAnswerResult(isCorrectAnswer: Bool) {}
    
    func updateButtons(enabled: Bool) {}
    
    func showQuizResultAlert(statisticsResult: ypquiz.QuizStatisticsResult) {}
    
    func showErrorAlert() {}
    
    func showQuizQuestion(quizQuestionViewModel: ypquiz.QuizQuestionViewModel) {}
}

final class MovieQuizPresenterTests: XCTest {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter()
        presenter.setupViewController(viewControllerMock)
        
        let emptyData = Data()
        let quizQuestion = QuizQuestion(imageData: emptyData, question: "Question Text", answer: true)
        let viewModel = presenter.convert(quizQuestion: quizQuestion)
        
        XCTAssertNotNil(viewModel)
        
        XCTAssertNotNil(viewModel?.image)
        XCTAssertEqual(viewModel?.question, "Question Text")
        XCTAssertEqual(viewModel?.answer, true)
    }
}
