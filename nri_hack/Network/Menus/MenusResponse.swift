//
//  MenusResponse.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import Alamofire

// MARK: - Response

struct MenusResponse: Codable {
    let records: [MenusRecord]
}

struct MenusRecord: Codable {
    let memuId: MenuId
    let carbohydrate: MenuCarbohydrate
    let shopName: MenuShopName
    let shopId: MenuShopId
    let price: MenuPrice
    let calorie: MenuCalorie
    let photoUrl: MenuPhotoUrl
    
    var time: Int {
        /// TODO 緯度経度から計算する必要がある。今回は暫定値。
        guard let ka = Int(calorie.value) else { return 0 }
        return ka/20
    }
}

struct MenuId: Codable {
    let value: String
}

struct MenuCarbohydrate: Codable {
    let value: String
}

struct MenuShopName: Codable {
    let value: String
}

struct MenuShopId: Codable {
    let value: String
}

struct MenuPrice: Codable {
    let value: String
}

struct MenuCalorie: Codable {
    let value: String
}

struct MenuPhotoUrl: Codable {
    let value: String
}
