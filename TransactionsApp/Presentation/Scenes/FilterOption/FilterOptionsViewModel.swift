//
//  FilterOptionsViewModel.swift
//  TransactionsApp
//
//  Created by Behnam on 12/26/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol FilterOptionsViewModelInput {
    func getCategories()
    func selectCategory(_ indexPath: IndexPath)
    func transferCategories()
}
protocol FilterOptionsViewModelOutput {
    var categoriesTransmitter: Observable<[Category]> { get }
    var categories: Observable<[FilterOptionsModels.CategoryModel]> { get }
}

protocol FilterOptionsViewModel: FilterOptionsViewModelInput, FilterOptionsViewModelOutput {}

class FilterOptionsViewModelImpl: FilterOptionsViewModel {
    
    var categories: Observable<[FilterOptionsModels.CategoryModel]> { categoriesSubject.asObservable() }
    var categoriesTransmitter: Observable<[Category]> { categoriesTransmitterSubject.asObservable() }
    
    var categoriesSubject = BehaviorRelay<[FilterOptionsModels.CategoryModel]>(value: [])
    var categoriesTransmitterSubject = BehaviorRelay<[Category]>(value: [])
    private let useCase: GetCategoriesUseCase
    init(useCase: GetCategoriesUseCase) {
        self.useCase = useCase
    }
    
    func getCategories() {
        let categories = useCase.execute().map(FilterOptionsModels.CategoryModel.init(category: ))
        self.categoriesSubject.accept(categories)
    }
    
    func selectCategory(_ indexPath: IndexPath) {
        var categories = categoriesSubject.value
        var category = categories[indexPath.row]
        if categories.filter({ $0.selected }).count == 1 && category.selected { return }
        category.selected.toggle()
        categories.remove(at: indexPath.row)
        categories.insert(category, at: indexPath.row)
        categoriesSubject.accept(categories)
    }
    
    func transferCategories() {
        categoriesTransmitterSubject.accept(categoriesSubject.value.map(Category.init(model: )))
    }
}
