//
//  AppConfig.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

struct AppConfig {
    static var version: String = "1.0.0"
    static let isExamine: Bool = false
    
    static var isGrayMode: Bool = false {
        didSet {
            AppGrayManager.setGrayMode(isGrayMode)
        }
    }
    
    /// 接口域名
    static var baseURL: URL {
        if isExamine {
            return URL(string: "https://iptvmobiletest.snctv.cn:88/hk_multidisplay_api")!
        } else {
            return URL(string: "https://dpfxapi.snctv.cn")!
        }
    }
    
    /// 网宿域名
    static var cncBaseURL: URL {
        if isExamine {
            return URL(string: "https://iptvmobiletest.snctv.cn:88/hk_multidisplay_cloudv")!
        } else {
            return URL(string: "https://dpfxapi.snctv.cn/cloudv")!
        }
    }

    /// 图片域名
    static var imageBaseURL: URL {
        if isExamine {
            return URL(string: "https://iptvmobiletest.snctv.cn:88/images")!
        } else {
            return URL(string: "https://dpfximage.snctv.cn/")!
        }
    }
    
    /// 即时通讯域名
    static var webSocketBaseURL: String {
        if isExamine {
            return "ws://10.23.190.107:8080/hk_multidisplay_webSocket/websocketserver"
        } else {
            return "wss://dpfxapi.snctv.cn/ws/websocketserver"
        }
    }
    
    /// 敏感词机审机审域名
    static var sensitiveCheckBaseURL: URL {
        if isExamine {
            return URL(string: "http://10.23.190.96:9643")!
        } else {
            return URL(string: "https://dpfxapi.snctv.cn")!
        }
    }
    
    /// web页域名
    static var webBaseURL: String {
        if isExamine {
            return "https://iptvmobiletest.snctv.cn:88/multidisplay/anouncement?type="
        } else {
            return "https://dpfx.snctv.cn/anouncement?type="
        }
    }
    
    /// 消息列表域名
    static var messageListURL: String {
        if isExamine {
            return "https://iptvmobiletest.snctv.cn:88/multidisplay/messageList?token="
        } else {
            return "https://dpfx.snctv.cn/messageList?token="
        }
    }
    
    /// 消息详情域名
    static var messageDetailURL: String {
        if isExamine {
            return "https://iptvmobiletest.snctv.cn:88/multidisplay/messageDetail?noticeKey="
        } else {
            return "https://dpfx.snctv.cn/messageDetail?noticeKey="
        }
    }
    
    /// 分享域名
    static var shareURL: String {
        if isExamine {
            return "https://iptvmobiletest.snctv.cn:88/multidisplay/share/"
        } else {
            return "https://dpfx.snctv.cn/share/"
        }
    }
}

struct App {
    static let bundleId: String = {
        return Bundle.main.bundleIdentifier ?? ""
    }()

    static let version: String = {
        guard let appInfo = App.info else {
            return ""
        }
        return (appInfo["CFBundleShortVersionString"] as? String) ?? ""
    }()

    static let build: String = {
        guard let appInfo = App.info else {
            return ""
        }
        return (appInfo[String(kCFBundleVersionKey)] as? String) ?? ""
    }()

    static let name: String = {
        guard let appInfo = App.info else {
            return ""
        }
        return (appInfo["CFBundleDisplayName"] as? String) ?? ""
    }()

    static let nameSpace: String = {
        guard let appInfo = App.info else {
            return ""
        }
        return (appInfo[String(kCFBundleExecutableKey)] as? String) ?? ""
    }()

    static let pathForDocuments: String = {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }()

    static let info: [String: Any]? = {
        let info = Bundle.main.infoDictionary
        return info
    }()
}
