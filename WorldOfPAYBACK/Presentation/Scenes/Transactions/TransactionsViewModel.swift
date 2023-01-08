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
    
    var transactions: Observable<[Transaction]> { transactionsSubject.asObservable() }
    var forcedError: Observable<Void> { forcedErrorSubject.asObservable() }
    var sumOfTransaction: Observable<String> { sumOfTransactionsSubject.asObservable() }
    var isLoading: Observable<Bool> { isLoadingSubject.asObservable() }
    var networkAvailable: Observable<Bool> {
        NetworkMonitor.shared.connectionStatus.asObservable()
    }
    
    private let transactionsUseCase: GetTransactionsUseCase
    private let updateCategories: UpdateSelectedCategoriesUseCase
    private var transactionsSubject = BehaviorRelay<[Transaction]>.init(value: [])
    private var forcedErrorSubject = PublishRelay<Void>()
    private var sumOfTransactionsSubject = PublishSubject<String>()
    private var isLoadingSubject = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()
    
    init(transactionsUseCase: GetTransactionsUseCase,
         updateCategories: UpdateSelectedCategoriesUseCase
    ) {
        self.transactionsUseCase = transactionsUseCase
        self.updateCategories = updateCategories
    }
    
    func fetchTransactions() {
        isLoadingSubject.onNext(true)
        transactionsSubject.accept([])
        Task {
            do {
                try await transactionsUseCase.fetch()
                let transactions = transactionsUseCase.getTransactions()
                self.observeTransactions(transactions, isRandomly: true)
            } catch {
                print(error)
            }
        }
    }
    
    func observeTransactions(_ transactions: [Transaction], isRandomly: Bool) {
        isLoadingSubject.onNext(false)
        if isRandomly {
            let randomInt = Int.random(in: 3...9)
            if (randomInt % 3) == 0 {
                forcedErrorSubject.accept(())
                return
            }
        }
        
        let sum = transactions.map { $0.transactionDetail.amount }.reduce(0, +)
        let currency = transactions.first?.transactionDetail.currency ?? ""
        transactionsSubject.accept(transactions)
        sumOfTransactionsSubject.onNext("\(sum) \(currency)")
    }
    
    func selectedTransaction(_ indexPath: IndexPath) -> Transaction {
        transactionsSubject.value[indexPath.row]
    }
    
    func filterTransactions(_ categories: [Category]) {
        updateCategories.execute(categories)
        let transactions = transactionsUseCase.getTransactions()
        self.observeTransactions(transactions, isRandomly: false)
    }
}
