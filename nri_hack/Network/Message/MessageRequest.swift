//
//  MessageRequest.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/20.
//  Copyright © 2019 HIromu. All rights reserved.
//

import Alamofire

// MARK: Request

struct MessageRequest: BaseRequestProtocol {
    
    typealias ResponseType = MenusResponse
    
    private let shopId: String
    private let shopUrl: String
    private let shopName: String
    
    init(shopId: String, shopUrl: String, shopName: String) {
        self.shopId = shopId
        self.shopUrl = shopUrl
        self.shopName = shopName
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var urlType: BaseURLType {
        return .message
    }
    
    var path: String {
        return "/test"
    }
    
    var parameters: Parameters? {
        return [
            "shopId": shopId,
            "shopUrl": shopUrl,
            "shopName": shopName
        ]
    }
}
