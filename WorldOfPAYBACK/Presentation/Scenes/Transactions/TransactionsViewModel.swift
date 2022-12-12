//
//  TransactionsViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 11/28/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol TransactionsViewModelInput {
    func fetchTransactions()
}
protocol TransactionsViewModelOutput {
    var transactions: Observable<[Transaction]> { get }
}

protocol TransactionsViewModel: TransactionsViewModelInput, TransactionsViewModelOutput {}

class TransactionsViewModelImpl: TransactionsViewModel {
    
    let transactionsUseCase: GetTransactionsUseCase
    var transactionsSubject = BehaviorRelay<[Transaction]>.init(value: [])
    var transactions: Observable<[Transaction]> { transactionsSubject.asObservable() }
    
    
    var disposeBag = DisposeBag()
    
    init(transactionsUseCase: GetTransactionsUseCase) {
        self.transactionsUseCase = transactionsUseCase
        
        
        self.transactionsSubject.subscribe(onNext: { transactions in
            print("Transactions Emit Event:", transactions.count)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchTransactions() {
        let transactions = transactionsUseCase.execute()
        transactionsSubject.accept(transactions)
    }
    
}
