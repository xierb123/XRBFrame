//
//  CGFloatExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

extension CGFloat {
    /// 获取适配高度
    func toFitHeight() -> CGFloat {
        return self * Constant.screenHeight / 812
    }
    /// 获取适配宽度
    func toFitWidth() -> CGFloat {
        return self * Constant.screenWidth / 375
    }
}
