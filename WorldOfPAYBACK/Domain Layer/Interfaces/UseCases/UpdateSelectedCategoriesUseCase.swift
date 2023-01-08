//
//  UpdateSelectedCategories.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 1/8/23.
//

import Foundation

protocol UpdateSelectedCategoriesUseCase {
    func execute(_ categories: [Category])
}
