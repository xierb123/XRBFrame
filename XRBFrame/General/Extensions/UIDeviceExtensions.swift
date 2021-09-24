//
//  UIDeviceExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import DeviceKit

// MARK: - Methods
extension UIDevice {
    /// Determine if it is an iPhone X series.
    func isXSeries() -> Bool {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return false
        }
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate?.window
            if let bottomSafeInset = window??.safeAreaInsets.bottom {
                // 获取底部安全区域高度，iPhone X/XS/XR 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
                if bottomSafeInset == 34.0 || bottomSafeInset == 21.0 {
                    return true
                }
            }
        }
        return false
    }
    
    /// 是否是早期型号（界定为iPhone 7）
    func isEarlier() -> Bool {
        switch Device.current.description {
        case "iPhone 2G",
             "iPhone 3G",
             "iPhone 3GS",
             "iPhone 4",
             "iPhone 4s",
             "iPhone 5",
             "iPhone 5 (GSM+CDMA)",
             "iPhone 5c (GSM)",
             "iPhone 5c (GSM+CDMA)",
             "iPhone 5s (GSM)",
             "iPhone 5s (GSM+CDMA)",
             "iPhone 6",
             "iPhone 6 Plus",
             "iPhone 6s",
             "iPhone 6s Plus",
             "iPhone SE":
            return true
        default:
            return false
        }
    }
}
