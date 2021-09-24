//
//  RequestParameterManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

struct RequestParameterManager {
    static func publicParameters(withType type: ResponseType) -> [String: String] {
        var params: [String: String] = [:]
        // 操作系统
        params["os"] = "iOS"
        // 版本号
        params["v"] = AppConfig.version
        // 设备唯一标识
        params["uuid"] = UDIDManager.getUDID()
        // 前端类型（1：android；2：iOS；3：web）
        params["terminal"] = "2"
        // 登录用户的授权令牌
        if let token = User.token {
            params["token"] = token
        }
        // 系统时间
        let timestamp = Date().milliStamp
        params["_timestamp"] = timestamp
        return params
    }

    static func insertPublicParameters(for parameters: [String: String], type: ResponseType) -> [String: String] {
        var params: [String: String] = publicParameters(withType: type)
        parameters.forEach {
            params[$0.key] = $0.value
        }
        return params
    }

    static func sign(for parameters: [String: Any]) -> String {
        var sign = "hiconiptv"
        let sortedArray = parameters.sorted(by: { $0.0 < $1.0 })
        for (key, value) in sortedArray {
            if key != "_timestamp" {
                let value = (value as? String) ?? "\(value)"
                sign.append(key + value)
            }
        }
        
        let timestamp = (parameters["_timestamp"] as? String) ?? Date().milliStamp
        sign.append("_timestamp" + timestamp)
        sign.append("hiconiptv")
        
        return sign.md5
    }
}

extension Dictionary where Key == String, Value == Any {
    var signed: [Key: Value] {
        var dict = self
        dict["_sign"] = RequestParameterManager.sign(for: dict)
        return dict
    }
}
