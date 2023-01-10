//
//  TransactionRepositoryProtocol.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/12/22.
//

import Foundation
import RxSwift

protocol TransactionRepository {
    var filteredTransactions: Observable<[Transaction]> { get }
    func fetchTransactions() async
    func updateSelected(categories: [Category])
    func fetchCategories() -> [Category]
    
}
