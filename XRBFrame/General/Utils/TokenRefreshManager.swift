//
//  TokenRefreshManager.swift
//  HiconMultiScreen
//
//  Created by 谢汝滨 on 2021/7/1.
//

import UIKit

class TokenRefreshManager {
    private static var liveTimer: Timer?
    
    static func startTimerForUpdateToken() {
        liveTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(self.refreshToken), userInfo: nil, repeats: true)
        RunLoop.current.add(liveTimer!, forMode: RunLoop.Mode.common)
        print("TokenRefreshManager - 启动计时器")
    }
    
    static func stopTimerForUpdateToken() {
        liveTimer?.invalidate()
        liveTimer = nil
        print("TokenRefreshManager - 关闭计时器")
    }
    
    /// 刷新token
    @objc static func refreshToken() {
        User.updateToken(onlyUpdate: true)
        print("TokenRefreshManager - 刷新token")
    }
}
