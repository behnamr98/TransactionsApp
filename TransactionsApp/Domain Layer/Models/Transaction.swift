//
//  Transaction.swift
//  TransactionsApp
//
//  Created by Behnam on 12/3/22.
//

import Foundation

struct Transaction: Codable {
    let partnerDisplayName: String
    let category: Int
    let transactionDetail: Details
    
    struct Details: Codable {
        let description: String?
        let bookingDate: Date
        let amount: Int
        let currency: String
    }
}

extension Transaction: Comparable {
    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.transactionDetail.bookingDate < rhs.transactionDetail.bookingDate
    }
    
    static func > (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.transactionDetail.bookingDate > rhs.transactionDetail.bookingDate
    }
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.category == rhs.category &&
        lhs.transactionDetail.amount == rhs.transactionDetail.amount &&
        lhs.transactionDetail.bookingDate == rhs.transactionDetail.bookingDate
    }
}
