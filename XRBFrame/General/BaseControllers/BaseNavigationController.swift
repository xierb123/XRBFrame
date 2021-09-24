//
//  BaseNavigationController.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

protocol BaseNavigationControllerProtocol {
    func pushViewController(_ viewController: UIViewController)
}

class BaseNavigationController: UINavigationController {
    override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }

    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNavigationBarHidden = false
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.endReceivingRemoteControlEvents()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // fix: sometimes push and then popback no tabbar error
        if viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
        
        if viewControllers.count > 1 {
            let index = viewControllers.count - 2
            (viewControllers[index] as? BaseNavigationControllerProtocol)?.pushViewController(viewController)
        }
    }
    
    @discardableResult
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        // fix: iOS14 missing TabBar on popping multiple ViewControllers
        if viewControllers.count > 1 {
            topViewController?.hidesBottomBarWhenPushed = false
        }
        return super.popToRootViewController(animated: animated)
    }
}
