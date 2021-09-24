//
//  StatisticsAPI.swift
//  HiconMultiScreen
//
//  Created by 谢汝滨 on 2021/1/6.
//

import Foundation
import Moya

enum StatisticsAPI {
    /// 数据统计接口
    case statistics(type: String, position: String?, contentKey: String?)
    
}

extension StatisticsAPI : TargetType {
    var baseURL: URL {
        return AppConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .statistics:
            return "/common/statistics"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .statistics(let type, let position, let contentKey):
            params["type"] = type
            if let position = position {
                params["position"] = position
            }
            if let contentKey = contentKey {
                params["contentKey"] = contentKey
            }
        }
        
        let encoding = method == .get ? URLEncoding.default : URLEncoding.httpBody
        return .requestParameters(parameters: params, encoding: encoding)
    }
}
