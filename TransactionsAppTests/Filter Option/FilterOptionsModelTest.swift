//
//  FilterOptionsViewModelTests.swift
//  TransactionsAppTests
//
//  Created by Behnam on 3/26/23.
//

import XCTest
@testable import TransactionsApp

class FilterOptionsModelsTests: XCTestCase {
    
    func test_categoryModelInitialization() {
        let category = Category(id: 1, isSelected: true)
        let categoryModel = FilterOptionsModels.CategoryModel(category: category)
        
        XCTAssertEqual(categoryModel.id, category.id)
        XCTAssertEqual(categoryModel.title, category.title)
        XCTAssertEqual(categoryModel.selected, category.isSelected)
    }
    
    func testCategoryModelConversion() {
        let categoryModel = FilterOptionsModels.CategoryModel(category: .init(id: 1, isSelected: true))
        let category = Category(model: categoryModel)
        
        XCTAssertEqual(category.id, categoryModel.id)
        XCTAssertEqual(category.isSelected, categoryModel.selected)
    }
    
}
