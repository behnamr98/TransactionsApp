//
//  Endpoints.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 1/10/23.
//

import Foundation

enum Endpoints: EndPointType {
    
    case getTransactions
    
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com/behnamr98/WorldOfPAYBACK")!
    }
    
    var path: String {
        return "/master/WorldOfPAYBACK/Resources/PBTransactions.json"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    
}
