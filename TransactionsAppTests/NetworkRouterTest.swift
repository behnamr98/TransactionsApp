//
//  NetworkRouterTest.swift
//  TransactionsAppTests
//
//  Created by Behnam on 1/11/23.
//

import XCTest
import RxSwift
@testable import TransactionsApp

final class NetworkRouterTest: XCTestCase {

    var sut: Router!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Router(session: .shared)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_buildURLRequest_testEndpoint_correctOne() throws {
        let endpoint: EndPointType = MockEndpoint()
        let request = sut.buildRequest(endpoint: endpoint)
        
        let httpMethod = try XCTUnwrap(request.httpMethod)
        XCTAssertEqual(httpMethod, endpoint.httpMethod.rawValue)
        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(url, endpoint.baseURL.appending(path: endpoint.path))
    }
}

private struct MockEndpoint: EndPointType {
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com/behnamr98/TransactionsApp")!
    }
    
    var path: String {
        return "/master/TransactionsApp/Resources/PBTransactions.json"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
}
