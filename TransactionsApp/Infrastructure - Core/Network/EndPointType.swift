//
//  EndPointType.swift
//  TransactionsApp
//
//  Created by Behnam on 1/9/23.
//

import Foundation
protocol EndPointType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var httpMethod: HTTPMethod { get }
}
