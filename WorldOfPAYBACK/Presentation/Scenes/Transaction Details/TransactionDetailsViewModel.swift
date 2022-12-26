//
//  DetailsTransactionViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/26/22.
//

import Foundation
import RxSwift

protocol TransactionDetailsViewModelInput {}
protocol TransactionDetailsViewModelOutput {
    var transaction: Transaction { get }
}

protocol TransactionDetailsViewModel: TransactionDetailsViewModelInput, TransactionDetailsViewModelOutput {}

class TransactionDetailsViewModelImpl: TransactionDetailsViewModel {
    
    var transaction: Transaction
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
}
