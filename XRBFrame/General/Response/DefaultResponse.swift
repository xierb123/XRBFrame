//
//  DefaultResponse.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

class DefaultResponse: BaseResponse {
    var isSuccessfulResponse: Bool {
        return code == 200
    }

    var isSuccessfulRetcode: Bool {
        return ret == 200 || ret == 22000
    }

    var ret: Int {
        let ret = results["ret"]
        if let value = ret as? Int {
            return value
        } else if let value = ret as? String {
            return value.toInt() ?? 0
        }
        return 0
    }

    var message: String {
        return (results["msg"] as? String) ?? ""
    }

    /// userType：1是授权用户，2是注册用户
    /// 授权用户只有绑定手机号后才能成为注册用户，否则一直通过第三方登录进来且没绑定手机号，永远是授权用户
    var userType: Int {
        var userType: Int?
        if let type = body?["user_type"] as? Int {
            userType = type
        } else if let type = body?["userType"] as? Int {
            userType = type
        }
        return userType ?? 0
    }

    var totalCount: Int {
        return (pageInfo?["totalCount"] as? Int) ?? 0
    }
    
    var isNoMore: Bool {
        if let nextPage = pageInfo?["nextPage"] as? Bool {
            return !nextPage
        }
        return true
    }

    var body: [String: Any]? {
        return results["data"] as? [String: Any]
    }

    var list: [[String: Any]]? {
        return results["data"] as? [[String: Any]]
    }

    private lazy var code: Int = {
        let code = result["code"]
        if let value = code as? Int {
            return value
        } else if let value = code as? String {
            return value.toInt() ?? 0
        }
        return 0
    }()

    private lazy var results: [String: Any] = {
        return (result["results"] as? [String: Any]) ?? [:]
    }()

    private lazy var pageInfo: [String: Any]? = {
        return results["pageInfo"] as? [String: Any]
    }()

    private var result: [String: Any]

    required init?(data: Any) {
        var result: [String: Any]?
        if let dict = data as? [String: Any] {
            result = dict
        } else if let jsonString = data as? String {
            result = try? jsonString.toJSON()
        } else if let data = data as? Data {
            result = try? data.toJSON()
        }

        if let result = result {
            self.result = result
        } else {
            return nil
        }
    }
}

extension DefaultResponse {
    func map<T: Codable>(_ type: T.Type) -> T? {
        guard let dict = body ?? list?.first else {
            return nil
        }
        return try? Mapper<T>.map(json: dict)
    }

    func mapArray<T: Codable>(_ type: T.Type) -> [T]? {
        guard let list = list else {
            return nil
        }
        return try? Mapper<T>.mapArray(jsonArray: list)
    }
}
