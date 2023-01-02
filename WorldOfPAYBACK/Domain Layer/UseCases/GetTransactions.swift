//
//  GetTransactions.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation

struct GetTransactions: GetTransactionsUseCase {
    
    let repository: TransactionRepositoryProtocol
    
    func execute() async throws ->  [Transaction] {
        sleep(2)
        let transactions = try await repository.fetchTransactions()
        return transactions.map { $0 }.sorted(by: >)
    }
}
