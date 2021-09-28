//
//  AppDelegate+settings.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/6.
//

import UIKit
import Bugly
import IQKeyboardManagerSwift

extension AppDelegate {
    func defaultSettings(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // 注册第三方开放平台
        registerOpenPlatform()
        // 网络监听
        NetworkReachabilityMonitor.startMonitoring()
        // 设置IQKeyboardManager
        setupIQKeyboardManager()
        // 启动Bugly
        Bugly.start(withAppId: BuglyConfig.appId)
    }
            
    func setupAppearance() {
        setupNavgationBar()
        setupScrollView()
    }

    private func setupNavgationBar() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor(hexString: "#2B2C2E"),
                                             .font: UIFont.systemFont(ofSize: 18.0)]
        navigationBar.shadowImage = UIImage(color: UIColor.clear,
                                            size: CGSize(width: Constant.screenWidth, height: 1.0 / UIScreen.main.scale))
        navigationBar.setBackgroundImage(UIImage(color: UIColor.white,
                                                 size: CGSize(width: Constant.screenWidth, height: Constant.navigationHeight)),
                                         for: .default)
    }
    
    private func setupScrollView() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }

        // Disable estimates for UITableView
        let tableView = UITableView.appearance()
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
    }
    
    private func registerOpenPlatform() {
        // 注册微信开放平台
        WechatOpenManager.shared.register()
        // 注册QQ开放平台
        TencentOpenManager.shared.register()
        // 注册微博开放平台
        WeiboOpenManager.shared.register()
    }
    
    private func setupIQKeyboardManager() {
        // 启用键盘管理
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        /*IQKeyboardManager.shared.disabledDistanceHandlingClasses = [CreateLiveViewController.self,
                                                                    CreatePushStreamViewController.self,
                                                                    CreateLiveMaterialViewController.self,
                                                                    HomeLiveViewController.self,
                                                                    HomeVideoViewController.self]*/
    }
}

