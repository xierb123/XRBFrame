//
//  ShareManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/19.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

struct ShareManager {
    /// 社会化分享
    ///
    /// - Parameters:
    ///   - type: 分享类型
    ///   - title: 标题(不能为空和nil)
    ///   - description: 消息内容，标题下面的描述文字(不能为空和nil)
    ///   - image: 本地图片名称或URLString，必须真实存在
    ///   - webpageUrl: 网页的url地址，不能为空且长度不能超过255
    static func share(to type: ShareType, title: String, description: String, image: String, webpageUrl: String, finishedHandle:(()->Void)? = nil) {
        var shareImage = image
        if !image.isValidHttpURL && !image.isValidHttpsURL {
            shareImage = AppConfig.imageBaseURL.appendingPathComponent(image).absoluteString
        }
        switch type {
        case .wxSceneTimeline, .wxSceneSession:
            WechatOpenManager.shared.share(type, title: title, description: Message.shareSolgan, image: shareImage, webpageUrl: webpageUrl)
            finishedHandle?()
        case .qqFriends:
            TencentOpenManager.shared.shareToQQFriends(title, description: Message.shareSolgan, image: shareImage, webpageUrl: webpageUrl)
            finishedHandle?()
        case .weibo:
            WeiboOpenManager.shared.share(title, description: Message.shareSolgan, image: shareImage, webpageUrl: webpageUrl)
            finishedHandle?()
        case .copy:
            UIPasteboard.general.string = webpageUrl
            Toast.show("复制链接成功")
        case .report:
            break
        }
        
    }
}
