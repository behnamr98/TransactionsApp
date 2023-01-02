//
//  TransactionRepositoryProtocol.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/12/22.
//

import Foundation

protocol TransactionRepositoryProtocol {
    func fetchTransactions() async throws -> [Transaction]
    func fetchCategories() -> [Category]
}
