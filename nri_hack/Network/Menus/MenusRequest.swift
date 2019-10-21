//
//  MenusRequest.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import Alamofire

// MARK: Request

struct MenusRequest: BaseRequestProtocol {
    
    enum QueryType: String {
        case carbohydrate, price
    }

    typealias ResponseType = MenusResponse
    
    private let queryType: QueryType?
    
    init(queryType: QueryType?) {
        self.queryType = queryType
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var urlType: BaseURLType {
        return .menu
    }
    
    var path: String {
        return "/k/v1/records.json"
    }
    
    var parameters: Parameters? {
        var params: Parameters = ["app": 3]
        if let type = queryType {
            params["query"] = "order by \(type) asc"
        }
        return params
    }
}
