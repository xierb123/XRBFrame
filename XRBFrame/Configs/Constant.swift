//
//  Constant.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

struct Constant {
    static var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    static var screenHeight: CGFloat { return UIScreen.main.bounds.height }
    static let margin: CGFloat = 10.0
    static let separatorHeight: CGFloat = 1.0 // UIScreen.main.scale
    static let navigationBarHeight: CGFloat = 44.0
    static var tabBarHeight: CGFloat { return UIDevice.current.isXSeries() ? 83.0 : 49.0 }
    static var dangerousAreaHeight: CGFloat { return UIDevice.current.isXSeries() ? 34.0 : 0.0 }
    static var navigationHeight: CGFloat { return statusBarHeight + navigationBarHeight }
    static var viewHeight: CGFloat { return screenHeight - navigationHeight }

    static var statusBarHeight: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate?.window
            if let safeAreaInsets = window??.safeAreaInsets {
                let top = safeAreaInsets.top
                if top > 0.0 {
                    return top
                }
            }
        }
        return UIDevice.current.isXSeries() ? 44.0 : 20.0
    }
}

struct Message {
    static let loadFailed = "服务器异常，请稍后重试"
    static let networkException = "连接服务器失败，请稍后重试"
    static let noNetwork = "网络未连接，请检查网络设置"
    static let loginSuccessful = "登录成功"
    static let loginFailed = "登录失败"
    static let registrationSuccessful = "注册成功"
    static let registrationFailed = "注册失败"
    static let bindSuccessfully = "绑定成功"
    static let bindFailed = "绑定失败"
    static let cancelAuth = "已取消授权"
    static let authFailed = "授权失败"
    static let smsSentSuccessfully = "短信验证码已发送，请注意查收！"
    static let smsSentFailed = "获取验证码失败，请重新获取"
    static let phoneEmpty = "请输入手机号码"
    static let phoneWrong = "手机号格式不正确"
    static let resetPassword = "密码设置成功"
    static let invalidImage = "无效的图片资源"
    static let introEmpty = "他还没有添加个人简介，空空如也~~"
    static let usingWWAN = "正在使用移动网络，请注意流量消耗"
    static let liveUsingWWAN = "您正在使用移动网络，继续使用将消耗流量推流"
    static let shareSolgan = "人人都是导演"
    static let onOtherPlatform = "用户在其他设备登录"
    static let userDisabled = "用户已禁用"
    static let userLoggedOut = "用户已注销"
}

struct URLString {
    static let video = "https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/grimes/mac-grimes-tpl-cc-us-2018_1280x720h.mp4"
}

typealias voidHandle = () -> ()
typealias intHandle = (Int) -> ()
