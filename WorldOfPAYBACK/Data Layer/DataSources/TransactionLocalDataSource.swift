//
//  TransactionLocalDataSource.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 1/9/23.
//

import Foundation

protocol TransactionLocalDataSource {
    func prepareTransactions() throws -> TransactionDTOResponse.TransactionsDTO
}

struct TransactionJsonDataSource: TransactionLocalDataSource {
    
    func prepareTransactions() throws -> TransactionDTOResponse.TransactionsDTO {
        let jsonData = try getJsonData()
        return try JSONDecoder().decode(TransactionDTOResponse.TransactionsDTO.self, from: jsonData)
    }
    
    private func getJsonData() throws -> Data {
        guard let urlPath = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        return try Data(contentsOf: urlPath, options: .mappedIfSafe)
    }
}
