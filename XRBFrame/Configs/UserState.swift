//
//  UserState.swift
//  HiconMultiScreen
//
//  Created by devchena on 2021/1/18.
//

import Foundation

enum UserState {
    /// 正常
    case normal
    /// 用户未登陆
    case notLoggedIn
    /// token过期
    case tokenExpired
    /// 用户使用其他平台登录
    case onOtherPlatform
    /// 用户已禁用
    case userDisabled
    /// 用户已注销
    case userLoggedOut
}

extension UserState {
    static let stateKey = "userState"
    static let stateDidChangeNotificationName = Notification.Name("UserStateDidChange")
}

extension UserState {
    static func state(with ret: Int) -> UserState {
        switch ret {
        case 204, 605: // 204：用户未登录；605：用户未登录
            return .notLoggedIn
        case 205, 501, 502: // 205：token过期；501：令牌无效；502：无访问权限
            return .tokenExpired
        case 206: // 206：用户在其他设备登录
            return .onOtherPlatform
        case 304, 406: // 304：用户已禁用；406：用户已注销
            return ret == 304 ? .userDisabled : .userLoggedOut
        default:
            return .normal
        }
    }
}
