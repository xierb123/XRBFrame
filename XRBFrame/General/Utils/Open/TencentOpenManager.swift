//
//  TencentOpenManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class TencentOpenManager: NSObject {
    static let shared = TencentOpenManager()
    
    private var tencentOAuth: TencentOAuth?
    private var authCompletionHandler: AuthCompletionHandler?

    private override init() {
    }
    
    /// 注册
    func register() {
        tencentOAuth = TencentOAuth(appId: TencentConfig.appKey, andUniversalLink: TencentConfig.universalLink, andDelegate: self)
//        tencentOAuth?.authMode = .authModeClientSideToken
    }
    
    /// 发送授权请求
    func sendAuthRequset(completionHandler: @escaping AuthCompletionHandler) {
        guard isQQSupport() else {
            return
        }
        authCompletionHandler = completionHandler
        
        let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
        if tencentOAuth == nil {
            tencentOAuth = TencentOAuth(appId: TencentConfig.appKey, andUniversalLink: TencentConfig.universalLink, andDelegate: self)
//            tencentOAuth?.authMode = .authModeClientSideToken
        }
        tencentOAuth?.authorize(permissions)
        
    }
    
    /// 分享到QQ好友
    ///
    /// - Parameters:
    ///   - title: 标题(不能为空和nil)
    ///   - description: 消息内容，标题下面的描述文字(不能为空和nil)
    ///   - image: 本地图片名称或URLString，必须真实存在
    ///   - webpageUrl: 网页的url地址，不能为空且长度不能超过255
    func shareToQQFriends(_ title: String, description: String, image: String, webpageUrl: String) {
        guard isQQSupport() else {
            return
        }
        
        ShareImageManager.getImageData(image: image, shareType: .qqFriends) { (data) in
            guard let data = data else {
                Toast.show("空的图片资源")
                return
            }

            let obj = QQApiNewsObject.object(with: URL(string: webpageUrl), title: title, description: description, previewImageData: data) as? QQApiObject
            let request = SendMessageToQQReq(content: obj)
            QQApiInterface.send(request)
        }
    }
}

extension TencentOpenManager {
    private func isQQSupport() -> Bool {
        guard QQApiInterface.isQQInstalled() else {
            Toast.show("请安装腾讯QQ客户端")
            return false
        }
        guard QQApiInterface.isQQSupportApi() else {
            Alert.show(title: "温馨提示", message: "当前QQ版本不支持", actions: [
                CustomAlertAction(title: "确定", type: .default, handler: nil),
            ])
            return false
        }
        return true
    }
}

extension TencentOpenManager: QQApiInterfaceDelegate {
    func onReq(_ req: QQBaseReq!) {
        
    }
    
    func onResp(_ resp: QQBaseResp!) {
        guard resp.isKind(of: SendMessageToQQResp.self) else {
            return
        }
        
//        switch resp.result {
//        case "0":
//            Toast.show("分享成功")
//        case "-1":
//            Toast.show("参数错误")
//        case "-2":
//            Toast.show("该群不在自己的群列表里面")
//        case "-3":
//            Toast.show("上传图片失败")
//        case "-4":
//            Toast.show("取消分享")
//        case "-5":
//            Toast.show("客户端内部处理错误")
//        default:
//            break
//        }
    }
    
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
}

extension TencentOpenManager: TencentSessionDelegate {
    func tencentDidLogin() {
        guard let tencentOAuth = tencentOAuth, let accessToken = tencentOAuth.accessToken, !accessToken.isEmpty, let openId = tencentOAuth.openId, !openId.isEmpty else {
            Toast.show(Message.authFailed)
            return
        }
        
        let authInfo = ThirdPartyAuthInfo(type: .qq, code: openId, accessToken: accessToken)
        authCompletionHandler?(authInfo)
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        if cancelled {
            Toast.show(Message.cancelAuth)
        } else {
            Toast.show(Message.authFailed)
        }
    }
    
    func tencentDidNotNetWork() {
        Toast.show(Message.networkException)
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        
    }
}
