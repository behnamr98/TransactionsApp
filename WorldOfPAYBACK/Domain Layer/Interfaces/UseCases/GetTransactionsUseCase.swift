//
//  GetTransactions.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation

protocol GetTransactionsUseCase {
    func fetch() async throws
    func getTransactions() ->  [Transaction]
}
