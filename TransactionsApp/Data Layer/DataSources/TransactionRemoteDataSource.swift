//
//  TransactionRemoteDataSource.swift
//  TransactionsApp
//
//  Created by Behnam on 1/9/23.
//

import Foundation
import RxSwift

protocol TransactionRemoteDataSource {
    func prepareTransactionsFromServer() async throws -> Observable<TransactionDTOResponse.TransactionsDTO>
}

struct TransactionURLSessionDataSource: TransactionRemoteDataSource {
    
    let router: NetworkRouter
    
    func prepareTransactionsFromServer() async throws -> Observable<TransactionDTOResponse.TransactionsDTO> {
        let endpoint: EndPointType = Endpoints.getTransactions
        return router.request(endPoint: endpoint)
    }
}
