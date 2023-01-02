//
//  GetCategoriesUseCase.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/31/22.
//

import Foundation

protocol GetCategoriesUseCase {
    func execute() async throws -> [Category]
}
