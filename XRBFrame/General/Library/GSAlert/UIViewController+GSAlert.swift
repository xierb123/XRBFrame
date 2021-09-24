//
//  UIViewController+GSAlert.swift
//  GSAlert
//
//  Created by Gesen on 15/12/1.
//  Copyright © 2015年 Gesen. All rights reserved.
//

import UIKit

extension UIViewController {

    /**
     显示提示框
     
     - parameter type:       ActionSheet/Alert
     - parameter title:      标题
     - parameter message:    内容
     - parameter sourceView: iPad中，弹窗指向的View
     - parameter actions:    动作数组
     */
    func showAlert(type: AlertType, title: String?, message: String?, sourceView: UIView?, actions: [AlertAction]) {
        let alertController = UIAlertController.alertWithType(type: type, title: title, message: message, sourceView: sourceView, actions: actions)
        present(alertController, animated: true, completion: nil)
    }
}
