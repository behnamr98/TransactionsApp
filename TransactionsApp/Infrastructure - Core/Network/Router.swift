//
//  Router.swift
//  TransactionsApp
//
//  Created by Behnam on 1/9/23.
//

import Foundation
import RxSwift

protocol NetworkRouter {
    func request<T: Decodable>(endPoint: EndPointType) -> Observable<T>
}

protocol NetworkSession {
    func data(request: URLRequest) -> Observable<Data>
}


extension Reactive<URLSession>: NetworkSession {
//    func data(request: URLRequest) -> Observable<Data> {
//        return data(request: request)
//    }
}

struct Router: NetworkRouter {
    
    let session: URLSession
    
    func request<T: Decodable>(endPoint: EndPointType) -> Observable<T> {
        return session.rx.data(request: buildRequest(endpoint: endPoint))
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
    
    func buildRequest(endpoint: EndPointType) -> URLRequest {
        var request = URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
