//
//  UserDetailsEntity.swift
//  HiconTV
//
//  Created by user on 2019/11/18.
//  Copyright © 2019 HICON. All rights reserved.
//

import Foundation

class UserDetailsEntity: Codable {
    /// 用户昵称
    var customerName = ""
    /// 用户key
    var customerKey = ""
    /// 用户账号（手机号）
    var loginName = ""
    /// 头像
    var customerImg = ""
    /// 性别（0：未知；1：男；2：女）
    var sex = ""
    /// 所在地区
    var area = ""
    /// 是否设置过密码（0：否；1：是）
    var hasPassword = ""
    /// 微信昵称
    var weixinKey = ""
    /// 绑定的微信用户标识
    var weixinUnionId = ""
    /// 苹果昵称
    var appleName = ""
    /// 苹果用户标识
    var appleId = ""
    /// QQ昵称
    var qqName = ""
    /// QQKey
    var qqKey = ""
    /// 运营商属性（2：移动；4联通；8电信）
    var operatorBelong: Int = 0
    /// 个性签名
    var signature: String = ""
    /// 实名认证状态（0：未认证；1：已认证）
    var authStatus: String = ""
    /// 真实姓名
    var realName: String = ""
    /// 身份证号
    var idcard: String = ""
    /// 用户中心id
    var userCenterId: String = ""

    var isQQBind: Bool {
        return !qqName.isEmpty
    }
    
    var isAppleBind: Bool {
        return !appleName.isEmpty
    }
    
    var isWxBind: Bool {
        return !weixinKey.isEmpty
    }
    
    var isAuthenticated: Bool {
        set {
            authStatus = newValue ? "1" : "0"
        }
        get {
            return authStatus == "1"
        }
    }
}
