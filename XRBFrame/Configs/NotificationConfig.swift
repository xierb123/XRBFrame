//
//  NotificationConfig.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

extension Notification.Name {
    /// 登录成功
    static let loginSuccessful                      = Notification.Name("LoginSuccessful")
    /// 登出
    static let loggedOut                            = Notification.Name("LoggedOut")
    /// 刷新令牌
    static let refreshToken                         = Notification.Name("RefreshToken")
    /// 子页面开始滑动
    static let homeScrolled                         = Notification.Name("HomeScrolled")
    /// 子页面滑动结束
    static let homeScrolledEnd                      = Notification.Name("homeScrolledEnd")
    /// 导播结束
    static let liveBroadcastEnded                   = Notification.Name("liveBroadcastEnded")
    /// dismissToRootVC
    static let dismissToRootVC                      = Notification.Name("dismissToRootVC")
}
