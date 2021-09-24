//
//  UserEntity.swift
//  HiconTV
//
//  Created by devchena on 2020/3/6.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

class UserEntity: Codable {
    // 针对用户能力中心
    /// 访问令牌
    var access_token = ""
    /// 刷新令牌
    var refresh_token = ""
    
    // 针对终端
    /// 访问令牌
    var accessToken = ""
    /// 刷新令牌
    var refreshToken = ""
}
