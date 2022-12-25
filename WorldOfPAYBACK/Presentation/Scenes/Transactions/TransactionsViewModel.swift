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
    var sumOfTransaction: Observable<String> { get }
    var isLoading: Observable<Bool> { get }
}

protocol TransactionsViewModel: TransactionsViewModelInput, TransactionsViewModelOutput {}

class TransactionsViewModelImpl: TransactionsViewModel {
    
    var transactionsSubject = BehaviorRelay<[Transaction]>.init(value: [])
    var sumOfTransactionsSubject = PublishSubject<String>()
    var isLoadingSubject = PublishSubject<Bool>()
    
    var transactions: Observable<[Transaction]> { transactionsSubject.asObservable() }
    var sumOfTransaction: Observable<String> { sumOfTransactionsSubject.asObservable() }
    var isLoading: Observable<Bool> { isLoadingSubject.asObservable() }
    
    private let transactionsUseCase: GetTransactionsUseCase
    private var disposeBag = DisposeBag()
    
    init(transactionsUseCase: GetTransactionsUseCase) {
        self.transactionsUseCase = transactionsUseCase
    }
    
    var date = Date()
    func fetchTransactions() {
        isLoadingSubject.onNext(true)
        date = Date()
        Task {
            do {
                let transactions = try await transactionsUseCase.execute()
                self.observeTransactions(transactions)
            } catch {
                print(error)
            }
        }
    }
    
    func observeTransactions(_ transactions: [Transaction]) {
        let sum = transactions.map { $0.transactionDetail.amount }.reduce(0, +)
        let currency = transactions.first?.transactionDetail.currency ?? ""
        print(date.distance(to: Date()))
        isLoadingSubject.onNext(false)
        transactionsSubject.accept(transactions)
        sumOfTransactionsSubject.onNext("\(sum) \(currency)")
    }
    
}
