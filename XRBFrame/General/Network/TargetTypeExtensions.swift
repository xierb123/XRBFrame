//
//  TargetAPI.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    var sampleData: Data {
        return Data()
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
