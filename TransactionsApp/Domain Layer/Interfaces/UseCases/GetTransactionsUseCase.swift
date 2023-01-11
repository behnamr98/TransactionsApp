//
//  GetTransactions.swift
//  TransactionsApp
//
//  Created by Behnam on 12/3/22.
//

import Foundation
import RxSwift

protocol GetTransactionsUseCase {
    var filteredTransactions: Observable<[Transaction]> { get }
    func fetch() async
}
