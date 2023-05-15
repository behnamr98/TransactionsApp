//
//  DomainModelTest.swift
//  TransactionsAppTests
//
//  Created by Behnam on 5/14/23.
//

import XCTest
@testable import TransactionsApp

final class DomainModelTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_transaction_equatable() throws {
        let date = Date(timeIntervalSince1970: 1684059000)
        let transactionOne = Transaction(
            partnerDisplayName: "Test1", category: 1,
            transactionDetail: .init(description: nil, bookingDate: date, amount: 25000, currency: "USD"))
        
        let transactionTwo = Transaction(
            partnerDisplayName: "Test2", category: 1,
            transactionDetail: .init(description: "Nothing", bookingDate: date, amount: 25000, currency: "EUR"))
        
        XCTAssertEqual(transactionOne, transactionTwo)
    }
    
    func test_transaction_greaterOrLowerThan() throws {
        let firstDate = Date(timeIntervalSince1970: 1684059000)
        let secondDate = Date(timeIntervalSince1970: 1684050000)
        let transactionOne = Transaction(
            partnerDisplayName: "Test", category: 1,
            transactionDetail: .init(description: nil, bookingDate: firstDate, amount: 25000, currency: "USD"))
        
        let transactionTwo = Transaction(
            partnerDisplayName: "Test", category: 3,
            transactionDetail: .init(description: "Nothing", bookingDate: secondDate, amount: 25000, currency: "USD"))
        
        XCTAssertEqual(transactionOne > transactionTwo, true)
        XCTAssertEqual(transactionTwo < transactionOne, true)
    }
    
    func test_category_equatable() throws {
        let categoryOne = TransactionsApp.Category(id: 1, isSelected: false)
        let categoryTwo = TransactionsApp.Category(id: 1, isSelected: true)
        
        XCTAssertEqual(categoryTwo, categoryOne)
    }
    
    func test_category_greaterAndLowerThan() throws {
        let categoryOne = TransactionsApp.Category(id: 1, isSelected: false)
        let categoryTwo = TransactionsApp.Category(id: 2, isSelected: true)
        
        XCTAssertEqual(categoryOne > categoryTwo, false)
        XCTAssertEqual(categoryTwo < categoryOne, false)
    }
}
