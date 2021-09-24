//
//  DataSourceConfig.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

enum DiskCacheExpiry {
    /// 不过期（可能会存在误删除）
    case never
    /// 一定时长后过期
    case seconds(TimeInterval)
    /// 指定到期时间
    case date(Date)
}

struct DiskCacheOptions {
    var key: String
    var expiry: DiskCacheExpiry
    
    init?(key: String, expiry: DiskCacheExpiry? = nil) {
        if key.isEmpty {
            return nil
        } else {
            self.key = key
            self.expiry = expiry ?? .seconds(7 * 24 * 60 * 60)
        }
    }
}
