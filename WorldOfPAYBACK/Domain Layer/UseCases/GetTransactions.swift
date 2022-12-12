//
//  GetTransactions.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation

struct GetTransactions: GetTransactionsUseCase {
    func execute() -> [Transaction] {
        let transactions = [
        Transaction(name: "Trans 01"),
        Transaction(name: "Trans 02"),
        Transaction(name: "Trans 03"),
        Transaction(name: "Trans 04"),
        Transaction(name: "Trans 05"),
        Transaction(name: "Trans 06")]
        return transactions
    }
}
