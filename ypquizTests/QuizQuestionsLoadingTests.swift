//
//  QuizQuestionsLoadingTests.swift
//  ypquizTests
//
//  Created by Кирилл Ефремов on 21.10.2025.
//

import Foundation
import XCTest

@testable import ypquiz

final class MockNetworkClient: NetworkClientProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, any Error>) -> Void) {
        handler(.failure(NSError(domain: "No questions :(", code: -1)))
    }
}

final class MockQuizFailureQuestionsLoader: QuizQuestionsLoading {
    private let networkClient: NetworkClientProtocol = MockNetworkClient()
    
    func loadQuizQuestions(handler: @escaping (Result<ypquiz.QuizQuestions, any Error>) -> Void) {
        networkClient.fetch(url: URL(string: "https://google.com")!, handler: { result in
            switch result {
            case .success(_):
                handler(.success(.init(questions: [])))
                
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
}

final class QuizQuestionsLoadingTests: XCTestCase {
    
    // API key should be valid
    func testSuccess() throws {
        let loader = QuizQustionsLoader()
        
        let expectation = expectation(description: "Should return .success")
        var result: Result<QuizQuestions, Error>?
        
        loader.loadQuizQuestions { res in
            result = res
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 15)
        
        switch result {
        case .success(let questions):
            XCTAssert(questions.questions.isEmpty == false)
            
        default:
            XCTFail("Expected .success, got \(String(describing: result))")
        }
    }
    
        func testFailure() throws {
            let loader = MockQuizFailureQuestionsLoader()
    
            let expectation = expectation(description: "Should return .failure")
            var result: Result<QuizQuestions, Error>?
    
            loader.loadQuizQuestions { res in
                result = res
                expectation.fulfill()
            }
    
            wait(for: [expectation], timeout: 1)
    
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
    
            default:
                XCTFail("Expected .failure, got \(String(describing: result))")
            }
        }
}
