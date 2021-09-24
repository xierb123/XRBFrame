//
//  CGRectExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

extension CGRect {
    /// Convert to bounds.
    func toBounds() -> CGRect {
        return CGRect(origin: .zero, size: size)
    }
}
