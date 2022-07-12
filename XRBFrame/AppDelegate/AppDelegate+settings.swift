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
        //注册router
        setupRouter()
        // 网络监听
        NetworkReachabilityMonitor.startMonitoring()
        // 设置IQKeyboardManager
        setupIQKeyboardManager()
        // 启动Bugly
        Bugly.start(withAppId: BuglyConfig.appId)
        
        InitManager.startForJPush()
    }
    
    func setupRouter() {
        HKRouterConfig.routerSchemesName = "petTarger"
        HKRouterMap.initializeRouter(navigator: HKRouter.routerShared)
    }
            
    func setupAppearance() {
        setupNavgationBar()
        setupScrollView()
    }

    private func setupNavgationBar() {
        let titleTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(hexString: "#333333")!,
                                                                  .font:UIFont.systemFont(ofSize: 18.0, weight: .medium)]
        let shadowImage = UIImage(color: UIColor.clear,
                                  size: CGSize(width: Constant.screenWidth, height: 1.0 / UIScreen.main.scale))
        let backgroundImage = UIImage(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                                      size: CGSize(width: Constant.screenWidth, height: Constant.navigationHeight))
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationBar.shadowImage = shadowImage

        #if swift(>=5.5)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = titleTextAttributes
            appearance.backgroundImage = backgroundImage
            appearance.shadowImage = shadowImage
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        #endif
    }

    private func setupScrollView() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }

        // Disable estimates for UITableView
        let tableView = UITableView.appearance()
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        
        #if swift(>=5.5)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        #endif
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

