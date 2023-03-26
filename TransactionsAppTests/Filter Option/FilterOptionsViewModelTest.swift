//
//  FilterOptionsViewModelTests.swift
//  TransactionsAppTests
//
//  Created by Behnam on 3/26/23.
//

import RxSwift
import XCTest
@testable import TransactionsApp

final class FilterOptionsViewModelTest: XCTestCase {
    
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
    
    func test_getCategories_checkValuesBeSame() {
        // Given
        useCase.categories = [.init(id: 1), .init(id: 2)]
        // When
        viewModel.getCategories()
        // Then
        viewModel.categories
            .take(1)
            .subscribe(onNext: { categories in
                XCTAssertEqual(categories.count, 2)
                XCTAssertEqual(categories[0].id, 1)
                XCTAssertEqual(categories[0].title, "Category 1")
                XCTAssertEqual(categories[1].id, 2)
                XCTAssertEqual(categories[1].title, "Category 2")
            })
            .disposed(by: disposeBag)
    }
    
    func test_selectCategory_isSelectedMustHaveChanged() {
        // Given
        viewModel.categoriesSubject.accept([
            .init(category: .init(id: 1, isSelected: true)),
            .init(category: .init(id: 2, isSelected: false)),
            .init(category: .init(id: 3, isSelected: false))
        ])
        // When
        viewModel.selectCategory(.init(row: 1, section: 0))
        // Then
        viewModel.categories
            .take(1)
            .subscribe(onNext: { categories in
                XCTAssertEqual(categories[0].selected, true)
                XCTAssertEqual(categories[1].selected, true)
                XCTAssertEqual(categories[2].selected, false)
            })
            .disposed(by: disposeBag)
    }
    
    func testTransferCategories() {
        // Given
        viewModel.categoriesSubject.accept([
            .init(category: .init(id: 1, isSelected: true)),
            .init(category: .init(id: 2, isSelected: false))
        ])
        
        // When
        viewModel.transferCategories()
        
        // Then
        viewModel.categoriesTransmitter
            .take(1)
            .subscribe(onNext: { categories in
                XCTAssertEqual(categories.count, 2)
                XCTAssertEqual(categories[0].id, 1)
                XCTAssertEqual(categories[0].title, "Category 1")
                XCTAssertEqual(categories[1].id, 2)
                XCTAssertEqual(categories[1].title, "Category 2")
            })
            .disposed(by: disposeBag)
    }
    
}

class MockGetCategoriesUseCase: GetCategoriesUseCase {
    var categories: [TransactionsApp.Category] = []
    func execute() -> [TransactionsApp.Category] {
        return categories
    }
}
