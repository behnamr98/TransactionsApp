//
//  ResponseModelsTest.swift
//  TransactionsAppTests
//
//  Created by Behnam on 5/14/23.
//

import XCTest
@testable import TransactionsApp

final class ResponseModelsTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_convertDTO2Domain_shouldEqual() throws {
        let transaction = TransactionDTOResponse.TransactionDTO(
            partnerDisplayName: "Test",
            category: 1,
            transactionDetail: .init(description: nil, bookingDate: "2022-08-11T10:59:05+0200",
                                     value: .init(amount: 25000, currency: "USD")))
        
        let domainModel = transaction.toDomain()
        
        XCTAssertEqual(transaction.partnerDisplayName, domainModel.partnerDisplayName)
        XCTAssertEqual(transaction.category, domainModel.category)
        XCTAssertEqual(transaction.transactionDetail.value.amount, domainModel.transactionDetail.amount)
        XCTAssertEqual(transaction.transactionDetail.value.currency, domainModel.transactionDetail.currency)
        XCTAssertEqual(transaction.transactionDetail.bookingDate.date,
                       domainModel.transactionDetail.bookingDate)
    }

}
