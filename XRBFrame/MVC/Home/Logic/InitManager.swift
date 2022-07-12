//
//  InitManager.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/7/12.
//
//  各类初始化管理工具

import Foundation

struct InitManager {
    
}

//MARK: - 阿里云初始化
extension InitManager {
    static func startForAli() {
        print("初始化阿里云")
    }
}

//MARK: - 友盟初始化
extension InitManager {
    static func startForUMeng() {
        print("初始化友盟")
    }
}

//MARK: - 极光初始化
extension InitManager {
    static func startForJPush() {
        print("初始化极光")
    }
}

//MARK: - 腾讯初始化
extension InitManager {
    static func startForTencent() {
        print("初始化腾讯")
    }
}

 
