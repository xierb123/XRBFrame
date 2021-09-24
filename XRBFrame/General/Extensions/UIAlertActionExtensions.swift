//
//  UIAlertActionExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

extension UIAlertAction {
    /// 设置文字颜色
    func setTextColor(_ color: UIColor) {
        let key = "_titleTextColor"
        guard isPropertyExisted(key) else {
            return
        }
        self.setValue(color, forKey: key)
    }
    
    /// 是否存在某个属性
    func isPropertyExisted(_ propertyName: String) -> Bool {
        for name in UIAlertAction.propertyNames {
            if name == propertyName {
                return true
            }
        }
        return false
    }
    
    /// 取属性列表
    static var propertyNames: [String] {
        var outCount: UInt32 = 0
        guard let ivars = class_copyIvarList(self, &outCount) else {
            return []
        }
        var result = [String]()
        let count = Int(outCount)
        for i in 0..<count {
            let pro: Ivar = ivars[i]
            guard let string = ivar_getName(pro), let name = String(utf8String: string) else {
                continue
            }
            result.append(name)
        }
        return result
    }
}
