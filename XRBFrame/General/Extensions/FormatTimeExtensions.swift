//
//  FormatTimeExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

extension Int {
    /// 格式化时间
    func formateTime() -> String {
        if self <= 0 {
            return "00:00:00"
        }

        let hour = String(format: "%02ld", self / 3600)
        let minute = String(format: "%02ld", (self % 3600) / 60)
        let second = String(format: "%02ld", self % 60)
        return  String(format: "%@:%@:%@", hour, minute, second)
    }
}
