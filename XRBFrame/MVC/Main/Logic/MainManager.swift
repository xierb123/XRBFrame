//
//  MainManager.swift
//  HiconTV
//
//  Created by devchena on 2020/3/9.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

struct Main {
    /// tabBar控制器
    static var tabBarController: MainViewController? {
        if let tabBarController = AppDelegate.rootViewController as? MainViewController {
            return tabBarController
        }
        return nil
    }
    
    /// 当前导航控制器
    static var currentNavigationController: BaseNavigationController? {
        if let tabBarController = self.tabBarController {
            if let navigationController = Main.tabBarController?.presentedViewController as? BaseNavigationController {
                return navigationController
            } else {
                return tabBarController.selectedViewController as? BaseNavigationController
            }
        }
        return nil
    }
    
    /// 底部导航选中的第一个视图控制器
    static var selectedViewController: UIViewController? {
        return (Main.tabBarController?.selectedViewController as? BaseNavigationController)?.viewControllers.first
    }

    /// 导航的当前视图控制器
    static var currentViewControllerOfNavigation: UIViewController? {
        return currentNavigationController?.viewControllers.last
    }
    
    /// 导航的第一个视图控制器
    static var firstViewControllerOfNavigation: UIViewController? {
        return currentNavigationController?.viewControllers.first
    }
}

extension Main {
    static func open(tabItem item: TabBarItemType, params: [String: Any]? = nil) {
        guard let tabBarController = self.tabBarController else {
            return
        }
        guard let viewControllers = tabBarController.viewControllers else {
            return
        }
        
        let selectedIndex = tabBarController.selectedIndex
        for (index, viewController) in viewControllers.enumerated() {
            // 获取目标控制器
            var targetViewController = viewController
            let targetNavigationController = targetViewController as? BaseNavigationController
            if let firstViewController = targetNavigationController?.viewControllers.first {
                targetViewController = firstViewController
            }
            
            // 目标控制器属于指定类型
            if targetViewController.isKind(of: item.classType) {
                if index != selectedIndex {
                    tabBarController.selectedIndex = index
                    let currentNavigationController = viewControllers[selectedIndex] as? BaseNavigationController
                    currentNavigationController?.popToRootViewController(animated: true)
                    
                    // 更新导航栏，防止再次展示时导航栏闪动
                    if let firstViewController = currentNavigationController?.viewControllers.first as? BaseViewController {
                        let isNavigationBarHidden = firstViewController.isNavigationBarHidden
                        currentNavigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
                    }
                }
                
                targetNavigationController?.popToRootViewController(animated: true)
                (targetViewController as? TabBarComponentProtocol)?.tabBarComponentOpened(params)
                return
            }
        }
    }
}
