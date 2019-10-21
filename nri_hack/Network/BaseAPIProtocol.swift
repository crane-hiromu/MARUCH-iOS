//
//  BaseAPIProtocol.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import Alamofire

// MARK: - Type

enum BaseURLType {
    case menu, shop, message
    
    var path: URL {
        switch self {
        case .menu, .shop:
            return try! "https://devugspxa.cybozu.com".asURL()
        case .message:
            return try! "https://maruchi.herokuapp.com".asURL()
        }
    }
    
    var token: String {
        switch self {
        case .menu, .shop: return "JhnhFSatu7Ovitzg6JMVmn7ySRRkOcjI5eMnxpX1"
        case .message: return "fDNupcpu48D2PfdsPmz8SCeCn8uxCVuvEFPy72eK"
            
        }
    }
}

// MARK: - Base API Protocol

protocol BaseAPIProtocol {
    associatedtype ResponseType
    
    var method: HTTPMethod { get }
    var urlType: BaseURLType { get }
    var baseURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
}

extension BaseAPIProtocol {
    
    var baseURL: URL {
        return urlType.path
    }
    
    var headers: HTTPHeaders? {
        let params: [String: String] = [
            "X-Cybozu-API-Token": urlType.token
        ]
        return params
    }
}

// MARK: - BaseRequestProtocol

protocol BaseRequestProtocol: BaseAPIProtocol, URLRequestConvertible {
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
}

extension BaseRequestProtocol {
    
    var encoding: URLEncoding {
        return URLEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.timeoutInterval = TimeInterval(30)
        if let params = parameters {
            urlRequest = try encoding.encode(urlRequest, with: params)
        }
        
        return urlRequest
    }
}
