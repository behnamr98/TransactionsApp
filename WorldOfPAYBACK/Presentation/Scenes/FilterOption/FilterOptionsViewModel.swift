//
//  FilterOptionsViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/26/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol FilterOptionsViewModelInput {
    func getCategories()
    func selectCategory(_ indexPath: IndexPath)
}
protocol FilterOptionsViewModelOutput {
    var categories: Observable<[Category]> { get }
}

protocol FilterOptionsViewModel: FilterOptionsViewModelInput, FilterOptionsViewModelOutput {}

class FilterOptionsViewModelImpl: FilterOptionsViewModel {
    
    var categories: Observable<[Category]> { categoriesSubject.asObservable() }
    
    private var categoriesSubject = BehaviorRelay<[Category]>.init(value: [])
    private let useCase: GetCategoriesUseCase
    init(useCase: GetCategoriesUseCase) {
        self.useCase = useCase
    }
    
    func getCategories() {
        Task {
            let categories = try await useCase.execute()
            self.categoriesSubject.accept(categories)
        }
    }
    
    func selectCategory(_ indexPath: IndexPath) {
        var categories = categoriesSubject.value
        var category = categories[indexPath.row]
        category.selected.toggle()
        categories.remove(at: indexPath.row)
        categories.insert(category, at: indexPath.row)
        categoriesSubject.accept(categories)
    }
}
