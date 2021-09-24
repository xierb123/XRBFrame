//
//  ServiceConfig.swift
//  HiconMultiScreen
//
//  Created by devchena on 2021/3/11.
//

import Foundation

/// 微信
struct WechatConfig {
    static let appKey = "wxd6809eff13b38243"
    static let appSecret = "8581792f43563c664cfb16ff234ee80a"
    static let universalLink = "https://dpfxdl.snctv.cn/wechat/"
}

/// 腾讯QQ
struct TencentConfig {
    static let appKey = "101925056"
    static let universalLink = "https://dpfxdl.snctv.cn/tencent/"
}

/// 微博
struct WeiboConfig {
    static let appKey = "479633289"
    static let universalLink = "https://dpfxdl.snctv.cn/weibo/"
}

/// 网宿推流
struct CNCMobStreamConfig {
    static let appKey = "ihicon"
    static let authKey = "6E9BA42D671447F4A8E592ECFFD86F9B"
}

/// 腾讯云人脸核身
struct WBFaceVerifyConfig {
    static let appKey = "IDAsmwkp"
    static let licence = "TIXdA5GzNhEtR4enTnfB070+Anpqg76pT1LMEPfvROftVLQpjaT/QjDcmX3cD9F/08Wgy5f3wSALZ4sygkg5m3SWHvBCBhUe6FjMHMUuL7G8il4/n4SdHK8D1A90ZeSQugmAIxBH/128XkP+3H1aKmI6vGm0yyUQUoX6FtM5AsAmOf+qvAOQmhQG14Op7PrFjwDT6GLQQaCVrmCgcxSGdFgw+z26yfCmmfsfhI7k9T0t/d0lh288ln7bRL+IdcG/4d9oPZtq+PK7GObhWxPe3iCOeY5IJBJv/hUm985pp4nSqF8a1wFnX49nUv4cHVMDniDghDRh8BJLmEqflaSvoA=="
    static let apiVersion = "1.0.0"
}

/// 友盟推送
struct UMPushConfig {
    static let appKey = "5e61b6a0895cca9f040000bd"
    static let channel = "App Store"
}

/// Bugly
struct BuglyConfig {
    static let appId: String = "d157a4ab7a"
}
