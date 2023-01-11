//
//  TransactionsViewModel.swift
//  TransactionsApp
//
//  Created by Behnam on 11/28/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol TransactionsViewModelInput {
    func fetchTransactions()
    func filterTransactions(_ categories: [Category])
}
protocol TransactionsViewModelOutput {
    var transactions: Observable<[Transaction]> { get }
    var forcedError: Observable<Void> { get }
    var sumOfTransaction: Observable<String> { get }
    var isLoading: Observable<Bool> { get }
    var networkAvailable: Observable<Bool> { get }
    func selectedTransaction(_ indexPath: IndexPath) -> Transaction
}

protocol TransactionsViewModel: TransactionsViewModelInput, TransactionsViewModelOutput {}

class TransactionsViewModelImpl: TransactionsViewModel {
    
    var transactions: Observable<[Transaction]> { transactionsUseCase.filteredTransactions }
    var forcedError: Observable<Void> { forcedErrorSubject.asObservable() }
    var sumOfTransaction: Observable<String> { sumOfTransactionsSubject.asObservable() }
    var isLoading: Observable<Bool> { isLoadingSubject.asObservable() }
    var networkAvailable: Observable<Bool> {
        NetworkMonitor.shared.connectionStatus.asObservable()
    }
    
    private var cachedTransactions: [Transaction] = []
    private var forcedErrorSubject = PublishRelay<Void>()
    private var sumOfTransactionsSubject = PublishSubject<String>()
    private var isLoadingSubject = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()
    
    private let transactionsUseCase: GetTransactionsUseCase
    private let updateCategories: UpdateSelectedCategoriesUseCase
    
    init(transactionsUseCase: GetTransactionsUseCase,
         updateCategories: UpdateSelectedCategoriesUseCase
    ) {
        self.transactionsUseCase = transactionsUseCase
        self.updateCategories = updateCategories
        
        self.transactionsUseCase.filteredTransactions
            .subscribe { transactions in
                self.publishSumValue(transactions)
            }.disposed(by: disposeBag)
    }
    
    func fetchTransactions() {
        isLoadingSubject.onNext(true)
        
        let randomInt = Int.random(in: 3...9)
        if (randomInt % 3) == 0 {
            forcedErrorSubject.accept(())
        } else {
            Task {
                await transactionsUseCase.fetch()
                isLoadingSubject.onNext(false)
            }
        }
    }
    
    func publishSumValue(_ transactions: [Transaction]) {
        self.cachedTransactions = transactions
        isLoadingSubject.onNext(false)
        let sum = transactions.map { $0.transactionDetail.amount }.reduce(0, +)
        let currency = transactions.first?.transactionDetail.currency ?? ""
        sumOfTransactionsSubject.onNext("\(sum) \(currency)")
    }
    
    func selectedTransaction(_ indexPath: IndexPath) -> Transaction {
        cachedTransactions[indexPath.row]
    }
    
    func filterTransactions(_ categories: [Category]) {
        updateCategories.execute(categories)
    }
}
