//
//  GetCategories.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/31/22.
//

import Foundation

struct GetCategories: GetCategoriesUseCase {
    
    let repository: TransactionRepositoryProtocol
    
    func execute() -> [Category] {
        return repository.fetchCategories()
    }
}
