//
//  AuthConfig.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

typealias AuthCompletionHandler = (ThirdPartyAuthInfo) -> Void

enum ThirdPartyAuthType:String {
    /// 微信
    case wechat = "1"
    /// QQ
    case qq = "2"
    /// 苹果
    case apple = "3"
}

struct AppleAuthInfo {
    /// 苹果的identityToken
    var identityToken = ""
    /// 苹果唯一用户标识
    var userID: String = ""
    /// 苹果用户昵称
    var nickname: String?
}

struct ThirdPartyAuthInfo {
    var type: ThirdPartyAuthType
    /// 第三方授权码（目前支持：微信、QQ）
    var code: String = ""
    /// 苹果授权信息
    var appleAuthInfo: AppleAuthInfo?
    /// 客户端用户授权令牌
    var accessToken: String?
}
