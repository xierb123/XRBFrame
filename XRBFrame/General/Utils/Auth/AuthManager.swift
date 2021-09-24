//
//  AuthManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

struct AuthManager {
    /// 发送授权请求（用于登录或绑定）
    static func sendAuthRequset(type: ThirdPartyAuthType, completionHandler: @escaping AuthCompletionHandler) {
        switch type {
        case .wechat:
            WechatOpenManager.shared.sendAuthRequset(completionHandler: completionHandler)
        case .qq:
            TencentOpenManager.shared.sendAuthRequset(completionHandler: completionHandler)
        case .apple:
            if #available(iOS 13.0, *) {
                guard let vc = Main.currentViewControllerOfNavigation else {
                    return
                }
                AppleAuthManager.shared.sendAuthRequset(target: vc, completionHandler: completionHandler)
            }
        }
    }
}
