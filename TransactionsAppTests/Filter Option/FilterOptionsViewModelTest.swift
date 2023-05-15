//
//  FilterOptionsViewModelTests.swift
//  TransactionsAppTests
//
//  Created by Behnam on 3/26/23.
//

import RxSwift
import XCTest
import RxBlocking
@testable import TransactionsApp

final class FilterOptionsViewModelTest: XCTestCase {
    
    typealias CategoryModel = TransactionsApp.Category
    
    var viewModel: FilterOptionsViewModelImpl!
    var useCase: MockGetCategoriesUseCase!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        useCase = MockGetCategoriesUseCase()
        viewModel = FilterOptionsViewModelImpl(useCase: useCase)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        useCase = nil
        viewModel = nil
        disposeBag = nil
        try super.tearDownWithError()
    }
    
    func test_getCategories_checkValuesBeSame() throws {
        let categoriesExpectations: [CategoryModel] = [.init(id: 1), .init(id: 2)]
        useCase.categories = categoriesExpectations
        viewModel.getCategories()
        
        let categories = try XCTUnwrap(viewModel.categories.toBlocking().first())
        let mappedCategories = categoriesExpectations.map(
            FilterOptionsModels.CategoryModel.init(category: ))
        
        XCTAssertEqual(categories, mappedCategories)
    }
    
    func test_selectCategory_isSelectedMustHaveChanged() throws {
        // Given
        let categoriesExpectations: [CategoryModel] = [.init(id: 1), .init(id: 2), .init(id: 3)]
        useCase.categories = categoriesExpectations
        viewModel.getCategories()
        // When
        // Deselect first and third items
        viewModel.selectCategory(.init(row: 0, section: 0))
        viewModel.selectCategory(.init(row: 2, section: 0))
        
        // Then
        let categories = try XCTUnwrap(viewModel.categories.toBlocking().first())
        XCTAssertEqual(categories[0].selected, false)
        XCTAssertEqual(categories[1].selected, true)
        XCTAssertEqual(categories[2].selected, false)
    }
    
    func test_deselectAll_theLastOneShouldNotDeselect() throws {
        // Given
        let categoriesExpectations: [CategoryModel] = [.init(id: 1), .init(id: 2), .init(id: 3)]
        useCase.categories = categoriesExpectations
        viewModel.getCategories()
        // When
        // Deselect first and third items
        viewModel.selectCategory(.init(row: 0, section: 0))
        viewModel.selectCategory(.init(row: 1, section: 0))
        viewModel.selectCategory(.init(row: 2, section: 0))
        
        // Then
        let categories = try XCTUnwrap(viewModel.categories.toBlocking().first())
        XCTAssertEqual(categories[0].selected, false)
        XCTAssertEqual(categories[1].selected, false)
        XCTAssertEqual(categories[2].selected, true)
    }
    
    func test_transferCategories_shouldEqualBySelectedOnes() throws {
        // Given
        let categoriesExpectations: [CategoryModel] = [.init(id: 1), .init(id: 2), .init(id: 3)]
        useCase.categories = categoriesExpectations
        viewModel.getCategories()
        // When
        // Deselect first and third items
        viewModel.selectCategory(.init(row: 0, section: 0))
        viewModel.transferCategories()
        // Then
        let categories = try XCTUnwrap(viewModel.categoriesTransmitter.toBlocking().first())
        XCTAssertEqual(categories, categoriesExpectations)
    }
    
}

class MockGetCategoriesUseCase: GetCategoriesUseCase {
    var categories: [TransactionsApp.Category] = []
    func execute() -> [TransactionsApp.Category] {
        return categories
    }
}
