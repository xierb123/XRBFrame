//
//  CookieManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

enum CookieSourceType {
    case script
    case request
}

struct CookieManager {
    static func cookieSource(for type: CookieSourceType) -> String? {
        guard let token = User.token, let detailsEntity = User.detailsEntity else {
            return nil
        }

        var properties = [String: String]()
        properties["token"] = token
        properties["iOSWebViewFlag"] = "0"
        if let encodedCustomerName = detailsEntity.customerName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            properties["customer_name"] = encodedCustomerName
        }

        var cookieString = ""
        for (key, value) in properties {
            if type == .script {
                cookieString += "document.cookie='" + "\(key)=\(value)" + "';"
            } else {
                cookieString += "\(key)=\(value)" + ";"
            }
        }
        
        return cookieString
    }
}
