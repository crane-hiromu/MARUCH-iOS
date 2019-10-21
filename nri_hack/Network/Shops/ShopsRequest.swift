//
//  ShopsRequest.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import Alamofire

// MARK: Request

struct ShopsRequest: BaseRequestProtocol {
    
    typealias ResponseType = ShopsResponse
    
    var method: HTTPMethod {
        return .get
    }
    
    var urlType: BaseURLType {
        return .menu
    }
    
    var path: String {
        return "/k/v1/record.json"
    }
    
    var parameters: Parameters? {
        return [
            "app": 3,
            "id": 4
        ]
    }
}
