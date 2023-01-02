//
//  AppDependecyContainer.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/31/22.
//

import Foundation
import UIKit

class AppDependencyContainer {
    
    // MARK: - Properties
    let sharedTransactionsRepository: TransactionRepositoryProtocol
    
    // MARK: - Methods
    public init() {
        func makeTransactionsRepository() -> TransactionRepositoryProtocol {
            return MockTransactionRepository()
        }
        
        self.sharedTransactionsRepository = makeTransactionsRepository()
    }
    
    // Transactions List
    func makeTransactionsListViewController() -> UINavigationController {
        let detailsViewControllerFactory = { (transaction: Transaction) in
            return self.makeDetailsTransactionViewController(transaction)
        }
        
        let filterViewControllerFactory = {
            return self.makeFilterViewController()
        }
        
        let getTransactions = GetTransactions(repository: self.sharedTransactionsRepository)
        let viewModel = TransactionsViewModelImpl(transactionsUseCase: getTransactions)
        let rootVC = TransactionsViewController(viewModel, detailsViewControllerFactory, filterViewControllerFactory)
        return UINavigationController(rootViewController: rootVC)
    }
    
    // Details Transaction View Controller
    func makeDetailsTransactionViewController(_ transaction: Transaction) -> TransactionDetailsViewController {
        let viewModel = TransactionDetailsViewModelImpl(transaction: transaction)
        return TransactionDetailsViewController(viewModel)
    }
    
    // Filter Options View Controller
    func makeFilterViewController() -> FilterOptionsViewController {
        let useCase = GetCategories(repository: self.sharedTransactionsRepository)
        let viewModel = FilterOptionsViewModelImpl(useCase: useCase)
        return FilterOptionsViewController(viewModel)
    }
    
}
