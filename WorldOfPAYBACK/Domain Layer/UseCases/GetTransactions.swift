//
//  GetTransactions.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation

struct GetTransactions: GetTransactionsUseCase {
    
    let repository: TransactionRepositoryProtocol
    
    init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws ->  [Transaction] {
        let transactions = try await repository.fetchTransactions()
        return transactions.map { $0.toDomain() }
    }
}
