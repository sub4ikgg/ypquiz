//
//  ArrayTests.swift
//  ypquizTests
//
//  Created by Кирилл Ефремов on 21.10.2025.
//

import Foundation

import XCTest
@testable import ypquiz

final class ArrayTests: XCTest {

    func testSafeSubscriptReturnsElementWhenIndexIsValid() {
        let array = ["a", "b", "c"]
        let element = array[safe: 1]
        
        XCTAssertEqual(element, "b")
    }
    
    func testSafeSubscriptReturnsNilWhenIndexIsNegative() {
        let array = [10, 20, 30]
        let element = array[safe: -1]
        
        XCTAssertNil(element)
    }
    
    func testSafeSubscriptReturnsNilWhenIndexIsOutOfBounds() {
        let array = [1, 2, 3]
        let element = array[safe: 10]
        
        XCTAssertNil(element)
    }
    
    func testSafeSubscriptEmptyArrayAlwaysReturnsNil() {
        let emptyArray: [String] = []
        let element = emptyArray[safe: 0]
        
        XCTAssertNil(element)
    }
}
