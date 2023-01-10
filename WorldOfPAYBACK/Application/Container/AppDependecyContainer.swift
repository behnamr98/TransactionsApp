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
    let sharedTransactionsRepository: TransactionRepository
    lazy var sharedFilterViewModel: FilterOptionsViewModel = {
        let useCase = GetCategories(repository: self.sharedTransactionsRepository)
        return FilterOptionsViewModelImpl(useCase: useCase)
    }()
    
    // MARK: - Methods
    public init() {
        func makeTransactionsRepository() -> TransactionRepository {
            let localDataSource = TransactionJsonDataSource()
            let remoteDataSource = TransactionURLSessionDataSource(router: Router(session: .shared))
            return TransactionDataRepository(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
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
        
        let filterOptionsViewModelResolver = {
            return self.sharedFilterViewModel
        }
        
        let getTransactions = GetTransactions(repository: self.sharedTransactionsRepository)
        let updateCategories = UpdateSelectedCategories(repository: self.sharedTransactionsRepository)
        let viewModel = TransactionsViewModelImpl(transactionsUseCase: getTransactions, updateCategories: updateCategories)
        let rootVC = TransactionsViewController(viewModel, detailsViewControllerFactory, filterViewControllerFactory, filterOptionsViewModelResolver)
        return UINavigationController(rootViewController: rootVC)
    }
    
    // Details Transaction View Controller
    func makeDetailsTransactionViewController(_ transaction: Transaction) -> TransactionDetailsViewController {
        let viewModel = TransactionDetailsViewModelImpl(transaction: transaction)
        return TransactionDetailsViewController(viewModel)
    }
    
    // Filter Options View Controller
    func makeFilterViewController() -> UINavigationController {
        let viewModel = self.sharedFilterViewModel
        let viewController = FilterOptionsViewController(viewModel)
        return UINavigationController(rootViewController: viewController)
    }
    
}
