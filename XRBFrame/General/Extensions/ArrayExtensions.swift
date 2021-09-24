//
//  ArrayExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
    /// 交换元素
    mutating func swap(_ a: Int, _ b: Int) {
        guard a != b, a >= 0, b >= 0, a < count, b < count else {
            return
        }
        (self[a], self[b]) = (self[b], self[a])
    }
}
