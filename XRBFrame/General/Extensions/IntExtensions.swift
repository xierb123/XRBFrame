//
//  IntExtensions.swift
//  HiconMultiScreen
//
//  Created by 谢汝滨 on 2020/12/3.
//

import Foundation

extension Int{
    /// 播放量 / 点赞数展示规则
    func toPlayCount() -> String {
        if self <= 9999 {
            return String(format: "%d", self)
        } else {
            let item = Double(self) / 10000.0
            return String(format: "%.1fw", item)
        }
    }
}

