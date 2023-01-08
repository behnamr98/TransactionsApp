//
//  TransactionRepository.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation

class MockTransactionRepository: TransactionRepositoryProtocol {
    
    private var transactions: [Transaction] = []
    private var categories: [Category] = []
    
    func fetchTransactions() async throws {
        let decodedFile = try await decodedTransactionsFile()
        transactions = decodedFile.items.map { $0.toDomain() }
        updateCategories(self.transactions)
    }
    
    func getFilterTransactions() -> [Transaction] {
        let categoryIDs = categories.filter { $0.isSelected }.map { $0.id }
        return transactions.filter { categoryIDs.contains($0.category) }
    }
    
    func updateSelected(categories: [Category]) {
        self.categories = categories.sorted(by: <)
    }
    
    func fetchCategories() -> [Category] {
        return self.categories
    }
    
    private func updateCategories(_ transactions: [Transaction]) {
        var newCategories = Set(transactions.map { $0.category }).map { Category(id: $0) }
        categories.forEach { category in
            if let index = newCategories.firstIndex(where: { $0.id == category.id }) {
                newCategories.remove(at: index)
                newCategories.insert(category, at: index)
            }
        }
        self.categories = newCategories.sorted(by: <)
        print("categories: ", self.categories.count)
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
    func updateSelected(categories: [Category]) {}
    func fetchTransactions() async throws {}
    func getFilterTransactions() -> [Transaction] { [] }
    func fetchCategories() -> [Category] { [] }
}
