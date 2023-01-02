//
//  TransactionRepository.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation

class MockTransactionRepository: TransactionRepositoryProtocol {
    
    private var transactions: [Transaction] = []
    
    func fetchTransactions() async throws -> [Transaction] {
        let decodedFile = try await decodedTransactionsFile()
        transactions = decodedFile.items.map { $0.toDomain() }
        return transactions
    }
    
    func fetchCategories() -> [Category] {
        return Set(transactions.map { $0.category }).map { Category(id: $0) }
    }
    
    private func decodedTransactionsFile() async throws -> TransactionDTOResponse.TransactionsDTO {
        guard let urlPath = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        let jsonData = try Data(contentsOf: urlPath, options: .mappedIfSafe)
        return try JSONDecoder().decode(TransactionDTOResponse.TransactionsDTO.self, from: jsonData)
    }
}

struct NetworkTransactionRepository: TransactionRepositoryProtocol {
    func fetchTransactions() async throws -> [Transaction] {
        return []
    }
    
    func fetchCategories() -> [Category] {
        return []
    }
}
