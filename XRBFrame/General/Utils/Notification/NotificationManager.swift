//
//  NotificationManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

class NotificationManager: NSObject {
    private static let shared = NotificationManager()
    
    /// 注册通知
    static func register(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // 远程通知
        UMessage.setBadgeClear(true)
        UMessage.setAutoAlert(false)
        UMConfigure.setLogEnabled(AppConfig.isExamine)
        UMConfigure.initWithAppkey(UMPushConfig.appKey, channel: UMPushConfig.channel)
        
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions,
                                                entity: nil,
                                                completionHandler: { (granted, error) in
        })
        
        // 本地通知
        let center = UNUserNotificationCenter.current()
        center.delegate = shared
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
        })
    }
    
    /// 已注册远程通知
    static func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        UMessage.registerDeviceToken(deviceToken)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if UIApplication.shared.applicationState == .active {
            let request = notification.request
            let content = request.content

            if request.trigger is UNPushNotificationTrigger {
                NotificationManager.didReceiveRemoteNotification(content.userInfo, isActive: true)
            } else {
                NotificationManager.didReceiveLocalNotification(request: request, isActive: true)
            }
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let request = response.notification.request
        let content = request.content
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { () -> Void in
            if request.trigger is UNPushNotificationTrigger {
                NotificationManager.didReceiveRemoteNotification(content.userInfo, isActive: false)
            } else {
                NotificationManager.didReceiveLocalNotification(request: request, isActive: false)
            }
        }
    }
}

extension NotificationManager {
    /// 已接收到远程通知
    static func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any], isActive: Bool) {
        UMessage.didReceiveRemoteNotification(userInfo)
        
        // 解析通知信息
        var message = ""
        var targetURLString = ""
        
        for (key, value) in userInfo {
            if let k = key as? String {
                if k == "aps" {
                    if let aps = value as? [String: String] {
                        if let alert = aps["alert"]?.removingPercentEncoding {
                            message = alert
                        }
                    }
                } else if k == "target_url", let v = value as? String {
                    targetURLString = v
                }
            }
        }
        
        print("message: \(message)")
        print("targetURLString: \(targetURLString)")
    }
    
    /// 已接收到本地通知
    static func didReceiveLocalNotification(request: UNNotificationRequest, isActive: Bool) {
        let content = request.content
        guard let userInfo = content.userInfo as? [String : Any] else {
            return
        }
        
        print("userInfo: \(userInfo)")
    }
}

// MARK: 跳转到系统通知页面
extension NotificationManager {
    static func isNotificationOpend() -> Bool {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            return true
        } else {
            return false
        }
    }
    
    static func goToSystemSettingVC() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            let settingUrl = URL(string: "prefs:root=NOTIFICATIONS_ID")
            if let url = settingUrl, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
