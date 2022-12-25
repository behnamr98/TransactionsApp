//
//  TransactionDTOResponse.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation

struct TransactionDTOResponse: Decodable {
    
    struct TransactionsDTO: Decodable {
        let items: [TransactionDTO]
    }
    
    struct TransactionDTO: Decodable {
        let partnerDisplayName: String
        let category: Int
        let transactionDetail: Details
        
        func toDomain() -> Transaction {
            .init(partnerDisplayName: self.partnerDisplayName,
                  category: self.category,
                  transactionDetail: self.transactionDetail.toDomain())
        }
        
        struct Details: Decodable {
            let description: String?
            let bookingDate: String
            let value: Value
            
            func toDomain() -> Transaction.Details {
                .init(description: self.description,
                      bookingDate: self.bookingDate.date,
                      amount: self.value.amount,
                      currency: self.value.currency)
            }
            
            struct Value: Decodable {
                let amount: Int
                let currency: String
            }
        }
    }
    
}
