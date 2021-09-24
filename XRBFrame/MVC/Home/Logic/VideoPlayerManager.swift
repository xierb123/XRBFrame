//
//  VideoPlayerManager.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/2.
//
//  视频播放组件控制器

import UIKit
import ZFPlayer
import SwiftTimer

enum VideoType {
    /// 直播
    case live
    /// 点播
    case video
}
class VideoPlayerManager: NSObject {
    //MARK: - 单例实例化
    private static var shared: VideoPlayerManager?
    private override init() {}
    
    //MARK: - 全局变量
    /// 倒计时时间
    private var countTime = 10
    /// 倒计时计时器
    private var timer: SwiftCountDownTimer?
    /// 是否已经注入播放地址
    var hasPlayed: Bool = false
    
    //MARK: - 回调
    var stopPlayHandle: (() -> Void)? = nil
    var setPlayHandle: (() -> Void)? = nil
    var showWWAnDialogHandle: (() -> Void)? = nil
    
    //MARK: - 懒加载
    
    //MARK: - 实例化方法
    static func getSharedInstance() -> VideoPlayerManager {
        guard let instance = shared else {
            shared = VideoPlayerManager()
            return shared!
        }
        return instance
    }
    
    //MARK: - 注销方法
    static func releaseObject() {
        shared?.timer?.suspend()
        shared?.timer = nil
        shared = nil
        printLog("视频播放控制器单例被释放")
    }}

//MARK: - 对外暴露方法
extension VideoPlayerManager {
    /**
     <#方法名#>
     - parameter <#参数#>:        <#注释#>
     */
    
    /// 设置播放器类型
    func getVideoPlayerManager(with videpType: VideoType) -> ZFPlayerMediaPlayback {
        if videpType == .live {
            return ZFAVPlayerManager()
        } else {
            return ZFIJKPlayerManager()
        }
    }
    
    /// 添加网络环境改变通知
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)),
                                               name: NetworkReachability.statusDidChangeNotificationName, object: nil)
    }
    
    /// 移除通知
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 设置播放地址
    func setPlayUrl(player: ZFPlayerController, url: URL) {
        player.assetURL = url
        hasPlayed = true
    }
    
    /// 设置定时隐藏工具条
    func hideToolsView(finished: (() -> ())? = nil) {
        endTimer()
        timer = SwiftCountDownTimer(interval: .seconds(1), times: countTime, handler: {  (timer, index) in
            printLog("倒计时 - \(index)")
            if index == 0 {
                finished?()
                timer.suspend()
            }
        })
        timer?.start()
    }
    /// 关闭定时器
    func endTimer() {
        timer?.suspend()
        timer = nil
    }
}

//MARK: - 选择器事件(自定义方法)
extension VideoPlayerManager {
    /// 网络环境变化
    @objc private func networkStatusChanged(_ notification: NSNotification) {
        if let networkStatus = notification.userInfo?[NetworkReachability.statuskey] as? NetworkReachabilityStatus{
            switch networkStatus{
            case .reachable(.ethernetOrWiFi): // 您已切换到wifi网络
                break
            case .reachable(.cellular): // 您已切换到移动网络
                showWWAnDialogHandle?()
            case .notReachable: // 您的网络连接已断开
                stopPlayHandle?()
            case .unknown:
                print("It is unknown whether the network is reachable")
            }
        }
    }
}
