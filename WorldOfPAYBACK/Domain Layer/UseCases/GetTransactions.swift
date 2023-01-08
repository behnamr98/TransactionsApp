//
//  GetTransactions.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation

struct GetTransactions: GetTransactionsUseCase {
    
    let repository: TransactionRepositoryProtocol
    
    func fetch() async throws {
        sleep(2)
        try await repository.fetchTransactions()
    }
    
    func getTransactions() ->  [Transaction] {
        return repository.getFilterTransactions().map { $0 }.sorted(by: >)
    }
}
