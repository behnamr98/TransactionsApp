//
//  UpdateSelectedCategories.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 1/8/23.
//

import Foundation

struct UpdateSelectedCategories: UpdateSelectedCategoriesUseCase {
    
    let repository: TransactionRepository
    
    func execute(_ categories: [Category]) {
        if categories.isEmpty { return }
        repository.updateSelected(categories: categories)
    }
}
