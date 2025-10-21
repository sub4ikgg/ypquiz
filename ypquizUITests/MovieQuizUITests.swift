//
//  MovieQuizUITests.swift
//  ypquizUITests
//
//  Created by Кирилл Ефремов on 21.10.2025.
//

import Foundation
import XCTest

@testable import ypquiz

final class MovieQuizUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    private func waitQuizLoading() {
        let loader = app.activityIndicators["activityIndicator"]
        
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: loader)
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 15.0)
        XCTAssertEqual(result, .completed)
    }

    func testTappingYesOrNoChangesImage() {
        waitQuizLoading()
        
        let imageView = app.images["quizImageView"]
        XCTAssertTrue(imageView.exists)

        let firstValue = imageView.screenshot().pngRepresentation

        app.buttons["yesButton"].tap()

        sleep(2)
        
        let newValue = imageView.screenshot().pngRepresentation
        XCTAssertNotEqual(firstValue, newValue)
    }

    func testNoButtonAlsoChangesImage() {
        waitQuizLoading()
        
        let imageView = app.images["quizImageView"]
        XCTAssertTrue(imageView.exists)

        let firstValue = imageView.screenshot().pngRepresentation

        app.buttons["noButton"].tap()

        sleep(2)
        
        let newValue = imageView.screenshot().pngRepresentation
        XCTAssertNotEqual(firstValue, newValue)
    }
    
    private func tapTenTimesYesButton() {
        for _ in 1...10 {
            app.buttons["yesButton"].tap()
            sleep(2)
        }
    }
    
    func testQuizResultsAlertAppearsAndShowResults() {
        waitQuizLoading()
        
        tapTenTimesYesButton()
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
        
        let title = alert.label
        XCTAssertEqual(title, "Этот раунд окончен!")
        
        let messageText = alert.staticTexts.element(boundBy: 1).label
        XCTAssertTrue(messageText.contains("Ваш результат:"))
        
        let actionButton = alert.buttons.firstMatch
        XCTAssertEqual(actionButton.label, "Сыграть еще раз")
    }
    
    func testQuizResultsAlertDismissesAndQuizProgressResets() {
        waitQuizLoading()

        tapTenTimesYesButton()
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        
        let actionButton = alert.buttons.firstMatch
        actionButton.tap()
        
        XCTAssertTrue(alert.waitForNonExistence(timeout: 5))
        
        waitQuizLoading()
        
        let quizProgressLabel = app.staticTexts["quizProgressLabel"]
        XCTAssertEqual(quizProgressLabel.label, "1/10")
    }
}
