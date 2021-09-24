//
//  GSAlert8Helper.swift
//  GSAlert
//
//  Created by Gesen on 15/12/2.
//  Copyright © 2015年 Gesen. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /**
     快速创建UIAlertController
     
     - parameter type:       Alert/ActionSheet
     - parameter title:      标题
     - parameter message:    内容
     - parameter sourceView: iPad指向的视图（使用iPad时必须指定）
     - parameter actions:    动作集合
     
     - returns: UIAlertController
     */
    class func alertWithType(type: AlertType,
                             title: String?,
                             message: String?,
                             sourceView: UIView?,
                             actions: [AlertAction]) -> UIAlertController {
        
        let title = type == .alert ? (title ?? "") : title
        let alertControllerStyle = UIAlertController.Style(rawValue: type.rawValue)!
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
        
        for action in actions {
            let alertActionStyle = UIAlertAction.Style(rawValue: action.type.rawValue)!
            let alertAction = UIAlertAction(title: action.title, style: alertActionStyle) { (_) in
                action.handler?()
            }
            alertController.addAction(alertAction)
            
            switch action.type {
            case .default:
                alertAction.setTextColor(Color.theme)
            case .cancel:
                alertAction.setTextColor(UIColor.black.withAlphaComponent(0.6))
            case .destructive:
                alertAction.setTextColor(UIColor.black.withAlphaComponent(0.6))
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView!
            alertController.popoverPresentationController?.sourceRect = sourceView!.bounds
        }
        
        return alertController
    }
    
    /**
     在主控制器上弹框，便捷方法
     */
    func show() { present(animated: true, completion: nil) }
    
    /**
     在主控制器上弹框，带参数
     
     - parameter animated:   是否使用动画
     - parameter completion: 完成的回调
     */
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    /**
     递归从合适的控制器上弹框
     
     - parameter controller: 待定的控制器
     - parameter animated:   是否使用动画
     - parameter completion: 完成的回调
     */
    func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController, let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else if let tabVC = controller as? UITabBarController, let selectedVC = tabVC.selectedViewController {
            presentFromController(controller: selectedVC, animated: animated, completion: completion)
        } else {
            controller.present(self, animated: animated, completion: completion)
        }
    }
    
    open override var shouldAutorotate: Bool {
        return true
    }
}
