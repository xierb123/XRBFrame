//
//  WeiboOpenManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class WeiboOpenManager: NSObject {
    static let shared = WeiboOpenManager()
    
    private override init() {
    }
    
    /// 注册
    func register() {
        WeiboSDK.registerApp(WeiboConfig.appKey, universalLink: WeiboConfig.universalLink)
    }
    
    /// 分享到新浪微博
    ///
    /// - Parameters:
    ///   - title: 标题（必须存在，可为空）
    ///   - description: 消息内容，标题下面的描述文字（可选）
    ///   - image: 本地图片名称或URLString，必须真实存在
    ///   - webpageUrl: 网页的url地址，不能为空且长度不能超过255
    func share(_ title: String, description: String?, image: String, webpageUrl: String) {
        guard WeiboSDK.isWeiboAppInstalled() else {
            Toast.show("请安装新浪微博客户端")
            return
        }
        
        ShareImageManager.getImageData(image: image, shareType: .weibo) { (data) in
            guard let data = data else {
                Toast.show("空的图片资源")
                return
            }

            guard let imageObject = WBImageObject.object() as? WBImageObject else {
                return
            }
            imageObject.imageData = data
            
            guard let message = WBMessageObject.message() as? WBMessageObject else {
                return
            }
            message.imageObject = imageObject
            message.text = title + webpageUrl
            
            let sendMessageToWeiboRequest = WBSendMessageToWeiboRequest()
            sendMessageToWeiboRequest.message = message
            WeiboSDK.send(sendMessageToWeiboRequest)
        }
    }
}

extension WeiboOpenManager: WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        guard response.isKind(of: WBSendMessageToWeiboResponse.self) else {
            return
        }

        switch response.statusCode {
        case .success:
            Toast.show("分享成功")
        case .userCancel:
            Toast.show("取消分享")
        case .sentFail:
            Toast.show("发送失败")
        case .authDeny:
            Toast.show("授权失败")
        case .userCancelInstall:
            Toast.show("取消安装微博客户端")
        case .shareInSDKFailed:
            Toast.show("分享失败")
        case .unsupport:
            Toast.show("不支持的请求")
        case .unknown:
            Toast.show("未知错误")
        default:
            break
        }
    }
}
