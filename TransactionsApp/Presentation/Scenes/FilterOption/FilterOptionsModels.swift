//
//  FilterOptionsModels.swift
//  TransactionsApp
//
//  Created by Behnam on 1/2/23.
//

import Foundation

struct FilterOptionsModels {
    
    struct CategoryModel {
        
        init(category: Category) {
            self.id = category.id
            self.title = category.title
            self.selected = category.isSelected
        }
        
        let id: Int
        let title: String
        var selected: Bool
    }
    
}

extension Category {
    init(model: FilterOptionsModels.CategoryModel) {
        self.init(id: model.id, isSelected: model.selected)
    }
}
