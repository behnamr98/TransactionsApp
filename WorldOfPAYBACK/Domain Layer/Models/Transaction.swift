//
//  Transaction.swift
//  WorldOfPAYBACK
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
        let bookingDate: String
        let amount: Int
        let currency: String
    }
}
