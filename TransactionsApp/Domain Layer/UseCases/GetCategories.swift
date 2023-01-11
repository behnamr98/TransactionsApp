//
//  GetCategories.swift
//  TransactionsApp
//
//  Created by Behnam on 12/31/22.
//

import Foundation

struct GetCategories: GetCategoriesUseCase {
    
    let repository: TransactionRepository
    
    func execute() -> [Category] {
        return repository.fetchCategories()
    }
}
