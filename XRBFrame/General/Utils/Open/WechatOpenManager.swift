//
//  WechatManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class WechatOpenManager: NSObject {
    static let shared = WechatOpenManager()
    
    private var authCompletionHandler: AuthCompletionHandler?

    private override init() {
    }
    
    /// 注册
    func register() {
        WXApi.registerApp(WechatConfig.appKey, universalLink: WechatConfig.universalLink)
    }

    /// 发送授权请求
    func sendAuthRequset(completionHandler: @escaping AuthCompletionHandler) {
        guard isWXAppSupport() else {
            return
        }

        authCompletionHandler = completionHandler
        
        let request = SendAuthReq()
        request.scope = "snsapi_userinfo"
        request.state = "wx_auth_authorization_state"
        WXApi.send(request)
    }
    
    /// 分享到微信好友或朋友圈
    ///
    /// - Parameters:
    ///   - type: 微信好友或微信朋友圈
    ///   - title: 标题(可选)
    ///   - description: 消息内容，标题下面的描述文字(可选)
    ///   - image: 本地图片名称或URLString，必须真实存在
    ///   - webpageUrl: 网页的url地址，不能为空且长度不能超过255
    func share(_ type: ShareType, title: String?, description: String?, image: String, webpageUrl: String) {
        guard type == .wxSceneSession || type == .wxSceneTimeline else {
            return
        }
        guard isWXAppSupport() else {
            return
        }

        ShareImageManager.getImageData(image: image, shareType: .wxSceneSession) { (data) in
            guard let data = data else {
                Toast.show("空的图片资源")
                return
            }

            let mediaMessage = WXMediaMessage()
            let webpageObject = WXWebpageObject()
            webpageObject.webpageUrl = webpageUrl
            mediaMessage.mediaObject = webpageObject
            mediaMessage.thumbData = data
            if let title = title {
                mediaMessage.title = title
            }
            if let description = description {
                mediaMessage.description = description
            }
            
            let scene = Int32(type == .wxSceneSession ? WXSceneSession.rawValue : WXSceneTimeline.rawValue)
            let sendMessageToWXRequest = SendMessageToWXReq()
            sendMessageToWXRequest.bText = false
            sendMessageToWXRequest.scene = scene
            sendMessageToWXRequest.message = mediaMessage
            WXApi.send(sendMessageToWXRequest)
        }
    }
        
    /// 分享微信小程序
    ///
    /// - Parameters:
    ///   - webpageUrl: 兼容低版本的网页链接
    ///   - userName: 小程序的userName
    ///   - path: 小程序的页面路径（不填默认拉起小程序首页）
    ///   - imageData: 小程序新版本的预览图二进制数据（大小不能超过128k）
    ///   - title: 小程序标题
    ///   - description: 小程序描述
    ///   https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Share_and_Favorites/iOS.html
    func shareMiniProgram(webpageUrl: String,
                          userName: String,
                          path: String? = nil,
                          imageData: Data,
                          title: String,
                          description: String) {
        
        guard isWXAppSupport() else {
            return
        }

        let object = WXMiniProgramObject()
        object.webpageUrl = webpageUrl
        object.userName = userName
        object.withShareTicket = true
        object.hdImageData = imageData
        
        if let path = path, path.length > 0 {
            object.path = path
        }

        let message = WXMediaMessage()
        message.title = title
        message.description = description.count >= 1024 ? String(description.prefix(1024)) : description
        // 兼容旧版本节点的图片，小于32KB，新版本优先
        // 使用WXMiniProgramObject的hdImageData属性
        message.thumbData = nil
        message.mediaObject = object

        let request = SendMessageToWXReq()
        request.bText = false
        request.message = message
        request.scene = Int32(WXSceneSession.rawValue)
        WXApi.send(request)
    }
    
    /// 跳转到微信小程序
    ///
    /// - Parameters:
    ///   - userName: 小程序的userName
    ///   - path: 小程序的页面路径（不填默认拉起小程序首页）
    ///   https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Launching_a_Mini_Program/iOS_Development_example.html
    func launchMiniProgram(userName: String, path: String? = nil) {
        guard isWXAppSupport() else {
            return
        }

        let request = WXLaunchMiniProgramReq()
        request.miniProgramType = .release
        request.userName = userName
        
        if let path = path, path.length > 0 {
            request.path = path
        }
        
        WXApi.send(request) { (success) in
            if !success {
                Toast.show("打开商城失败")
            }
        }
    }
}

extension WechatOpenManager {
    private func isWXAppSupport() -> Bool {
        guard WXApi.isWXAppInstalled() else {
            Toast.show("请先安装微信")
            return false
        }
        guard WXApi.isWXAppSupport() else {
            Alert.show(title: "温馨提示", message: "当前微信版本不支持", actions: [
                CustomAlertAction(title: "确定", type: .default, handler: nil),
            ])
            return false
        }
        return true
    }
}

extension WechatOpenManager: WXApiDelegate {
    func onResp(_ resp: BaseResp) {
        if let authResp = resp as? SendAuthResp {
            switch authResp.errCode {
            case WXSuccess.rawValue:
                if let code = authResp.code {
                    let authInfo = ThirdPartyAuthInfo(type: .wechat, code: code)
                    authCompletionHandler?(authInfo)
                }
            case WXErrCodeUserCancel.rawValue:
                Toast.show(Message.cancelAuth)
            default:
                Toast.show(Message.authFailed)
            }
        } else if let miniProgramResp = resp as? WXLaunchMiniProgramResp {
            debugPrint("miniProgramResp extMsg: \(String(describing: miniProgramResp.extMsg))")
        }
    }
}
