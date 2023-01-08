//
//  TransactionRepositoryProtocol.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/12/22.
//

import Foundation

protocol TransactionRepositoryProtocol {
    func fetchTransactions() async throws
    func getFilterTransactions() -> [Transaction]
    func updateSelected(categories: [Category])
    func fetchCategories() -> [Category]
    
}
