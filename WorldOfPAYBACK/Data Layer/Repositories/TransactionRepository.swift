//
//  TransactionRepository.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation

struct MockTransactionRepository: TransactionRepositoryProtocol {
    
    func fetchTransactions() async throws -> [TransactionDTOResponse.TransactionDTO] {
        guard let urlPath = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        let jsonData = try Data(contentsOf: urlPath, options: .mappedIfSafe)
        let decoded = try JSONDecoder().decode(TransactionDTOResponse.TransactionsDTO.self, from: jsonData)
        return decoded.items
    }
    
}

struct NetworkTransactionRepository: TransactionRepositoryProtocol {
    func fetchTransactions() async throws -> [TransactionDTOResponse.TransactionDTO] {
        return []
    }
}
