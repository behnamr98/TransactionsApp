//
//  AppDelegate.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 11/28/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let repository = MockTransactionRepository()
        let useCase: GetTransactionsUseCase = GetTransactions(repository: repository)
        let viewModel: TransactionsViewModel = TransactionsViewModelImpl(transactionsUseCase: useCase)
        let rootVC = TransactionsViewController(viewModel)
        let navigationVC = UINavigationController(rootViewController: rootVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        return true
    }

}

