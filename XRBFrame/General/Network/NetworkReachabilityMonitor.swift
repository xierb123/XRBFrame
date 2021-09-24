//
//  NetworkReachabilityMonitor.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Alamofire

typealias NetworkReachabilityStatus = NetworkReachabilityManager.NetworkReachabilityStatus

struct NetworkReachability {
    static let statuskey = "networkReachabilityStatus"
    static let statusDidChangeNotificationName = Notification.Name("NetworkReachabilityStatusDidChange")
}

struct NetworkReachabilityMonitor {
    static var isReachable: Bool {
        return reachabilityManager?.isReachable ?? false
    }

    static var reachabilityStatus: NetworkReachabilityStatus {
        return reachabilityManager?.status ?? .unknown
    }

    private static let reachabilityManager = NetworkReachabilityManager()

    /// 开启网络状态的监听
    static func startMonitoring() {
        var reachabilityStatus = self.reachabilityStatus
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            if reachabilityStatus == status {
                return
            } else {
                reachabilityStatus = status
            }

            switch status {
            case .reachable(.ethernetOrWiFi):
                Toast.show("您已切换到wifi网络")
            case .reachable(.cellular):
                Toast.show("您已切换到移动网络")
            case .notReachable:
                Toast.show("您的网络连接已断开")
            case .unknown:
                print("It is unknown whether the network is reachable")
            }
            
            NotificationCenter.default.post(name: NetworkReachability.statusDidChangeNotificationName,
                                            object: nil,
                                            userInfo: [NetworkReachability.statuskey: status])
        })
    }

    /// 关闭网络状态的监听
    static func stopMonitoring() {
        reachabilityManager?.stopListening()
    }
}
