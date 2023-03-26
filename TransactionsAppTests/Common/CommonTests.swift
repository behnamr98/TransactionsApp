//
//  CommonTests.swift
//  TransactionsAppTests
//
//  Created by Behnam on 3/26/23.
//

import XCTest
@testable import TransactionsApp

final class CommonTests: XCTestCase {

    func test_dateFormatter_GMTTimeZone() throws {
        let customDate = Date(timeIntervalSince1970: 1672567800) //  January 1, 2023 10:10:00 AM
        let dateFormatter = DateFormatter.localizedFormatter
        
        dateFormatter.timeZone = TimeZone(identifier: "Europe/London")
        let dateString = dateFormatter.string(from: customDate)
        XCTAssertEqual(dateString, "2023-01-01 10:10:00")
    }
    
    func test_dateFormatter_IranTimeZone() throws {
        let customDate = Date(timeIntervalSince1970: 1672567800) //  January 1, 2023 10:10:00 AM
        let dateFormatter = DateFormatter.localizedFormatter
        
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        let dateString = dateFormatter.string(from: customDate)
        XCTAssertEqual(dateString, "2023-01-01 13:40:00")
    }

}
