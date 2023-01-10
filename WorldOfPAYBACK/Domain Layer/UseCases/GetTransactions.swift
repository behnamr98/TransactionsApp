//
//  GetTransactions.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation
import RxSwift

struct GetTransactions: GetTransactionsUseCase {
    
    let repository: TransactionRepository
    
    var filteredTransactions: Observable<[Transaction]> {
        repository.filteredTransactions
    }
    
    func fetch() async {
        sleep(2)
        await repository.fetchTransactions()
    }
    
}
