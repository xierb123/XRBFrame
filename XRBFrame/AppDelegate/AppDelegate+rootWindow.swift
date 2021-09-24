//
//  AppDelegate+rootWindow.swift
//  BasicFrame
//
//  Created by 谢汝滨 on 2021/8/12.
//

import UIKit

extension AppDelegate {
    
    /// 根视图控制器
    static var rootViewController: UIViewController? {
        set {
            if let appDelegate = UIApplication.shared.delegate {
                appDelegate.window??.rootViewController = newValue
            }
        }
        get {
            if let appDelegate = UIApplication.shared.delegate {
                return appDelegate.window??.rootViewController
            }
            return nil
        }
    }
    
    func setupRootWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = Color.background
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
    }
}
