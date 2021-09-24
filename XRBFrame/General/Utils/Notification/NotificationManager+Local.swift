//
//  NotificationManager+Local.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import WCDBSwift

/// 通知内容
struct NotificationContent {
    /// 目标日期（非通知触发日期，格式：yyyy-MM-dd HH:mm）
    var date: String = ""
    /// 通知标题
    var title: String = ""
    /// 通知正文
    var body: String = ""
    /// 通知id
    var identifier: String = ""
    /// 通知信息
    var userInfo: [AnyHashable : Any] = [:]
}

// MARK: 本地通知
extension NotificationManager {
    /// 添加本地通知
    static func addNotification(content: NotificationContent,
                                dateFormat: String = "yyyy-MM-dd HH:mm:ss",
                                completionHandler: @escaping (Bool) -> Void) {
        
        guard let date = Date(fromString: content.date, format: dateFormat) else {
            Toast.show("预约失败")
            DispatchQueue.main.safeAsync {
                completionHandler(false)
            }
            return
        }
        
        // 触发通知时间（提前5分钟）
        let fireDate = date.addingTimeInterval(-5*60)

        // 能否预约
        let interval = fireDate.timeIntervalSince(Date())
        guard interval > 0 else {
            Toast.show("只能提前5分钟预约")
            DispatchQueue.main.safeAsync {
                completionHandler(false)
            }
            return
        }

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = content.title
        notificationContent.body = content.body
        notificationContent.userInfo = content.userInfo
        notificationContent.sound = .default
        
        let center = UNUserNotificationCenter.current()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: content.identifier, content: notificationContent, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            DispatchQueue.main.safeAsync {
                if error == nil {
                    completionHandler(true)
                } else {
                    Toast.show("预约失败")
                    completionHandler(false)
                }
            }
        })
    }
    
    /// 移除本地已触发的通知
    static func removeDeliveredNotification(withIdentifier identifier: String, needToast: Bool = true) {
        if identifier.isEmpty {
            return
        }

        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        
        if needToast {
            Toast.show("预约已取消")
        }
    }

    /// 移除本地未触发的通知
    static func removePendingNotification(withIdentifier identifier: String) {
        if identifier.isEmpty {
            return
        }

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        Toast.show("预约已取消")
    }
    
    /// 本地通知是否已触发
    static func isDeliveredNotification(withIdentifier identifier: String,
                                        completionHandler: @escaping (Bool) -> Void) {
        
        if identifier.isEmpty {
            DispatchQueue.main.safeAsync {
                completionHandler(false)
            }
            return
        }

        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            let requests = notifications.map { $0.request }
            for request in requests {
                if identifier == request.identifier {
                    DispatchQueue.main.safeAsync {
                        completionHandler(true)
                    }
                    return
                }
            }
            
            DispatchQueue.main.safeAsync {
                completionHandler(false)
            }
        }
    }
    
    /// 本地通知是否已订阅
    static func isSubscribedNotification(withIdentifier identifier: String,
                                         completionHandler: @escaping (Bool) -> Void) {
        
        if identifier.isEmpty {
            DispatchQueue.main.safeAsync {
                completionHandler(false)
            }
            return
        }

        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in
            for request in requests {
                if identifier == request.identifier {
                    DispatchQueue.main.safeAsync {
                        completionHandler(true)
                    }
                    return
                }
            }
            
            UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
                let requests = notifications.map { $0.request }
                for request in requests {
                    if identifier == request.identifier {
                        DispatchQueue.main.safeAsync {
                            completionHandler(true)
                        }
                        return
                    }
                }
                
                DispatchQueue.main.safeAsync {
                    completionHandler(false)
                }
            }
        })
    }
        
    /// 本地通知是否等待中（即未发送未触发）
    static func isPendingNotification(withIdentifier identifier: String,
                                      completionHandler: @escaping (Bool) -> Void) {
        
        if identifier.isEmpty {
            DispatchQueue.main.safeAsync {
                completionHandler(false)
            }
            return
        }

        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in
            for request in requests {
                if identifier == request.identifier {
                    DispatchQueue.main.safeAsync {
                        completionHandler(true)
                    }
                    return
                }
            }
            
            DispatchQueue.main.safeAsync {
                completionHandler(false)
            }
        })
    }
}
