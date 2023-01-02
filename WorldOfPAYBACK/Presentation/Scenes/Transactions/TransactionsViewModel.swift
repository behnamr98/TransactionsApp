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
    private var transactionsSubject = BehaviorRelay<[Transaction]>.init(value: [])
    private var forcedErrorSubject = PublishRelay<Void>()
    private var sumOfTransactionsSubject = PublishSubject<String>()
    private var isLoadingSubject = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()
    
    init(transactionsUseCase: GetTransactionsUseCase) {
        self.transactionsUseCase = transactionsUseCase
    }
    
    func fetchTransactions() {
        isLoadingSubject.onNext(true)
        transactionsSubject.accept([])
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
        isLoadingSubject.onNext(false)
        let randomInt = Int.random(in: 3...9)
        if (randomInt % 3) == 0 {
            forcedErrorSubject.accept(())
            return
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
        let categoryIDs = categories.map { $0.id }
        var transactions = transactionsSubject.value
        let filterTransactions = transactions.filter { categoryIDs.contains($0.category) }
        transactionsSubject.accept(filterTransactions)
    }
}
