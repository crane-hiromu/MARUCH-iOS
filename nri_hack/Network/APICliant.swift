//
//  APICliant.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import RxSwift
import Alamofire

// MARK: - API Cliant

struct APICliant {
    
    // MARK: Private Static Variables
    private static let successRange = 200..<400
    private static let contentType = ["application/json"]
    
    
    // MARK: Static Methods
    
    static func call<T, V>(_ request: T, _ disposeBag: DisposeBag, onSuccess: @escaping (V) -> Void, onError: @escaping (Error) -> Void)
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            
            _ = observe(request)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { onSuccess($0) },
                           onError: { onError($0) })
                .disposed(by: disposeBag)
    }
    
    static func observe<T, V>(_ request: T) -> Single<V>
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            
            return Single<V>.create { observer in
                let calling = callForData(request) { response in
                    switch response {
                    case .success(let result): observer(.success(result as! V))
                    case .failure(let error): observer(.error(error))
                    }
                }
                
                return Disposables.create() { calling.cancel() }
            }
    }
    
    private static func callForData<T, V>(_ request: T, completion: @escaping (APIResult) -> Void) -> DataRequest
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            
            return customAlamofire(request).responseJSON { response in
                switch response.result {
                case .success: completion(decodeData(request, response.data))
                case .failure(let error): completion(.failure(error))
                }
            }
    }
    
    private static func customAlamofire<T>(_ request: T) -> DataRequest
        where T: BaseRequestProtocol {
            
            return Alamofire
                .request(request)
                .validate(statusCode: successRange)
                .validate(contentType: contentType)
    }
    
    private static func decodeData<T, V>(_ request: T, _ data: Data?) -> APIResult
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            
            if let d = data, let result = try? JSONDecoder(type: .convertFromSnakeCase).decode(V.self, from: d) {
                return .success(result)
                
            } else {
                return .failure(ErrorResponse(dataContents: String(data: data ?? Data(), encoding: .utf8)))
                
            }
            
    }
    
}

// MARK: - JSONDecoder Extension

extension JSONDecoder {
    
    convenience init(type: JSONDecoder.KeyDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = type
    }
    
}

// MARK: - ResultType

enum APIResult {
    case success(Codable)
    case failure(Error)
}

// MARK: - ErrorResponse

struct ErrorResponse: Error, CustomStringConvertible {
    let description: String = "-- Decode Error --"
    var dataContents: String?
}
