//
//  AddressAPI.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import Moya

enum AddressAPI {
    /// 地理区域
    case list
}

extension AddressAPI: TargetType {
    var baseURL: URL {
        return AppConfig.baseURL
    }

    var path: String {
        switch self {
        case .list:
            return "/shippingAddress/areaList"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestParameters(parameters: [:], encoding: URLEncoding.default)
    }
}
