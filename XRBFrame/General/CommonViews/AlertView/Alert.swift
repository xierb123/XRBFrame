//
//  Alert.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

struct Alert {
    /// 提示框
    ///
    /// - Parameters:
    ///   - sourceView: 弹窗指向的View
    ///   - title: 标题
    ///   - message: 内容
    ///   - actions: 动作数组
    static func show(in sourceView: UIView? = nil,
                     title: String? = nil,
                     message: String? = nil,
                     actions: [CustomAlertAction]) {
        
        DispatchQueue.main.async {
            guard let superview = sourceView ?? UIApplication.shared.keyWindow else {
                return
            }
            
            let alertView = AlertView()
            alertView.show(title: title, message: message, actions: actions)
            superview.addSubview(alertView)
            superview.bringSubviewToFront(alertView)
            
            alertView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    /// 提示框
    ///
    /// - Parameters:
    ///   - sourceView: 弹窗指向的View
    ///   - type: 提示类型
    ///   - id: 直播ID
    ///   - actions: 动作数组
    static func show(in sourceView: UIView? = nil,
                     type: CustomAlertType,
                     id: String? = nil,
                     actions: [CustomAlertAction] = []) {
        
        DispatchQueue.main.async {
            guard let superview = sourceView ?? UIApplication.shared.keyWindow else {
                return
            }

            let alertView = AlertView()
            alertView.show(type: type, id: id, actions: actions)
            superview.addSubview(alertView)
            superview.bringSubviewToFront(alertView)
            
            alertView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
}
