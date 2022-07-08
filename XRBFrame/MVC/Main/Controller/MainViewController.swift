//
//  MainViewController.swift
//  HiconTV
//
//  Created by devchena on 2020/2/18.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import ESTabBarController_swift

protocol TabbarRefreshTargetProtocol {
    func refreshTarget()
}

class MainViewController: ESTabBarController {
    
    var firstClick: (index: Int, date: Date, isSkip: Bool)?
    var lastIndex: Int = -1
    
    override var prefersStatusBarHidden: Bool {
        return selectedViewController?.prefersStatusBarHidden ?? false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? .default
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return selectedViewController?.preferredStatusBarUpdateAnimation ?? .none
    }

    override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarSettings()
        setViewControllers()
        defaultSettings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.frame = UIScreen.main.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.frame = UIScreen.main.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.frame = UIScreen.main.bounds
    }

    private func tabBarSettings() {
        let containerSize = CGSize(width: Constant.screenWidth, height: 27.0)
        //let shadowImage = UIImage(named: "ic_tabbar_shadow_irregularity")?.stretchLeftAndRight(containerSize: containerSize)
        let shadowImage = UIImage(named: "ic_tabbar_shadow")
        let backgroundImage = UIImage()

        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance.copy()
            appearance.backgroundImage = backgroundImage
            appearance.backgroundColor = UIColor.white
            appearance.shadowImage = shadowImage
            tabBar.standardAppearance = appearance
        } else {
            tabBar.isTranslucent = false
            tabBar.backgroundImage = backgroundImage
            tabBar.backgroundColor = UIColor.white
            tabBar.shadowImage = shadowImage
        }
        

        shouldHijackHandler = { tabbarController, viewController, index in
            func isTarget() -> Bool {
                return index == 2
            }
            
            if let firstClick = self.firstClick, firstClick.index == index, firstClick.isSkip == false{
                if Date().secondsSince(firstClick.date) < 0.5 { // 0.5秒内完成双击视为双击
                    if let target = (viewController as? BaseNavigationController)?.viewControllers.first as? TabbarRefreshTargetProtocol {
                        target.refreshTarget()
                    }
                    self.firstClick = nil
                    return isTarget()
                }
            }
            self.firstClick = (index: index, date: Date(), isSkip: index != self.lastIndex)
            self.lastIndex = index
            return isTarget()
            
        }
        
        didHijackHandler = { tabBarController, viewController, index in
            
            if index == 2 { // 发送
                let remoteControlVC = SendViewController()
                let navigationController = BaseNavigationController(rootViewController: remoteControlVC)
                navigationController.modalPresentationStyle = .fullScreen
                tabBarController.presentVC(navigationController)
            }
        }
    }
    
    private func setViewControllers() {
        var navigationControllers: [BaseNavigationController] = []
        let itemTypes: [TabBarItemType] = [.home, .live, .send, .find, .user]
        for itemType in itemTypes {
            let viewController = itemType.viewController
            viewController.tabBarItem = ESTabBarItem(itemType.contentView, title: itemType.title,
                                                     image: itemType.image, selectedImage: itemType.selectedImage)
            navigationControllers.append(BaseNavigationController(rootViewController: viewController))
        }

        viewControllers = navigationControllers
    }
    
    private func defaultSettings() {
        // 更新token
        User.updateToken()
        // 获取用户详情
        User.getDetails()
        // 获取地理区域信息
        AddressManager.requestGeographicArea()
    }
}
