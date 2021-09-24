//
//  Toast.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import Toast_Swift

typealias CustomToastPosition = ToastPosition

enum Toast {
    private static let style: ToastStyle = {
        var style = ToastStyle()
        style.maxWidthPercentage = 0.8 - 64.0 / Constant.screenWidth
        style.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        style.messageColor = UIColor.white
        style.messageFont = UIFont.systemFont(ofSize: 14.0)
        style.cornerRadius = 20.0
        style.horizontalPadding = 32.0
        style.verticalPadding = 11.5
        return style
    }()
        
    static func show(_ message: String, position: CustomToastPosition = .center) {
        if message.isEmpty {
            return
        }

        DispatchQueue.main.safeAsync {
            UIApplication.shared.keyWindow?.makeToast(message,
                                                      duration: 2.5,
                                                      position: position,
                                                      style: style)
        }
    }
}
