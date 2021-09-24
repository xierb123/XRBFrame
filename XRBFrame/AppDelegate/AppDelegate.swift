//
//  AppDelegate.swift
//  BasicFrame
//
//  Created by 谢汝滨 on 2021/8/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupAppearance()
        defaultSettings(with: launchOptions)
        setupRootWindow()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //NotificationManager.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return [.portrait, .landscapeRight]
    }
}
