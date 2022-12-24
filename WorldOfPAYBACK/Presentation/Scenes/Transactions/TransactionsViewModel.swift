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
    private var disposeBag = DisposeBag()
    
    init(transactionsUseCase: GetTransactionsUseCase) {
        self.transactionsUseCase = transactionsUseCase
    }
    
    func fetchTransactions() {
        Task {
            do {
                let transactions = try await transactionsUseCase.execute()
                transactionsSubject.accept(transactions)
            } catch {
                print(error)
            }
        }
    }
    
}
