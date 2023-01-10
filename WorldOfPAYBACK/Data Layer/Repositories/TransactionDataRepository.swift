//
//  TransactionRepository.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/3/22.
//

import Foundation
import RxSwift
import RxRelay

class TransactionDataRepository: TransactionRepository {
    
    var filteredTransactions: Observable<[Transaction]> { filteredTransactionsSubject.asObservable() }
    
    private var filteredTransactionsSubject = BehaviorRelay<[Transaction]>(value: [])
    private var disposeBag = DisposeBag()
    private var transactions: [Transaction] = []
    private var categories: [Category] = []
    
    private let localDataSource: TransactionLocalDataSource
    private let remoteDataSource: TransactionRemoteDataSource
    
    init(localDataSource: TransactionLocalDataSource, remoteDataSource: TransactionRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchTransactions() async {
        do {
            try await remoteDataSource.prepareTransactionsFromServer()
                .map {  $0.items.map { $0.toDomain() } }
                .subscribe(onNext: { transactions in
                    self.transactions = transactions
                    self.publishFilterTransactions(transactions)
                }).disposed(by: disposeBag)
            
        } catch {
            fetchTransactionsFromLocal()
        }
    }
    
    func publishFilterTransactions(_ transactions: [Transaction]) {
        updateCategories(transactions)
        let categoryIDs = categories.filter { $0.isSelected }.map { $0.id }
        let filteredTransactions = transactions.filter { categoryIDs.contains($0.category) }
        filteredTransactionsSubject.accept(filteredTransactions)
    }
    
    func updateSelected(categories: [Category]) {
        self.categories = categories.sorted(by: <)
        publishFilterTransactions(self.transactions)
    }
    
    func fetchCategories() -> [Category] {
        return self.categories
    }
    
    private func fetchTransactionsFromLocal() {
        let decodedTransactions = try? self.localDataSource.prepareTransactions()
        self.transactions = (decodedTransactions?.items ?? []).map { $0.toDomain() }
        publishFilterTransactions(transactions)
    }
    
    private func updateCategories(_ transactions: [Transaction]) {
        var newCategories = Set(transactions.map { $0.category }).map { Category(id: $0) }
        categories.forEach { category in
            if let index = newCategories.firstIndex(where: { $0.id == category.id }) {
                newCategories.remove(at: index)
                newCategories.insert(category, at: index)
            }
        }
        self.categories = newCategories.sorted(by: <)
    }
}
