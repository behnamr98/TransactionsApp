//
//  GetCategoriesUseCase.swift
//  TransactionsApp
//
//  Created by Behnam on 12/31/22.
//

import Foundation

protocol GetCategoriesUseCase {
    func execute() -> [Category]
}
