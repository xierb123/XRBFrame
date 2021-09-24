//
//  UIResponderExtensions.swift
//  HiconMultiScreen
//
//  Created by devchena on 2020/12/11.
//

import UIKit

extension UIResponder {
    /// 获取当前视图控制器
    func findCurrentViewController() -> UIViewController? {
        guard let next = next else {
            return nil
        }
        if next is UIViewController {
            return next as? UIViewController
        }
        return next.findCurrentViewController()
    }
}
