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
    var forcedError: Driver<Void> { get }
    var sumOfTransactions: Driver<String> { get }
    var isLoading: Driver<Bool> { get }
    var networkAvailable: Driver<Bool> { get }
    func selectedTransaction(_ indexPath: IndexPath) -> Transaction
}

protocol TransactionsViewModel: TransactionsViewModelInput, TransactionsViewModelOutput {}

class TransactionsViewModelImpl: TransactionsViewModel {
    
    var networkAvailable: Driver<Bool> {
        NetworkMonitor.shared.connectionStatus.asDriver()
    }
    var transactions: Observable<[Transaction]> {
        transactionsUseCase.filteredTransactions
    }
    var forcedError: Driver<Void>
    var sumOfTransactions: Driver<String>
    var isLoading: Driver<Bool>
    
    private var cachedTransactions: [Transaction] = []
    private var forcedErrorSubject = PublishRelay<Void>()
    private var isLoadingSubject = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()
    
    private let transactionsUseCase: GetTransactionsUseCase
    private let updateCategories: UpdateSelectedCategoriesUseCase
    
    init(transactionsUseCase: GetTransactionsUseCase,
         updateCategories: UpdateSelectedCategoriesUseCase
    ) {
        self.transactionsUseCase = transactionsUseCase
        self.updateCategories = updateCategories
        self.sumOfTransactions = Observable.just("").asDriver(onErrorJustReturn: "")
        self.isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        self.forcedError = forcedErrorSubject.asDriver(onErrorJustReturn: ())
        
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
        let sum = Observable.just(transactions.map { $0.transactionDetail.amount }.reduce(0, +).stringValue)
        let currency = Observable.just(transactions.first?.transactionDetail.currency ?? "")
        
        sumOfTransactions = Observable.zip(sum, currency)
            .map { $0 + " " + $1 }
            .asDriver(onErrorJustReturn: "")
    }
    
    func selectedTransaction(_ indexPath: IndexPath) -> Transaction {
        cachedTransactions[indexPath.row]
    }
    
    func filterTransactions(_ categories: [Category]) {
        updateCategories.execute(categories)
    }
}
