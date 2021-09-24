//
//  UserConfig.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

struct User {
    static var state: UserState = .normal
    
    /// 用户
    static var entity: UserEntity? {
        didSet {
            if let entity = self.entity {
                if entity.access_token.isEmpty {
                    User.token = entity.accessToken
                    User.refreshToken = entity.refreshToken
                } else {
                    User.token = entity.access_token
                    User.refreshToken = entity.refresh_token
                }
                User.state = .normal
            } else {
                User.token = nil
                User.refreshToken = nil
            }
        }
    }

    /// 用户详情
    static var detailsEntity: UserDetailsEntity?

    /// 访问令牌
    static var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "user_token")
        }
        get {
            return UserDefaults.standard.string(forKey: "user_token")
        }
    }
    
    static var lastPhone: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "last_phone")
        }
        get {
            return UserDefaults.standard.string(forKey: "last_phone")
        }
    }
    
    /// 刷新令牌
    static var refreshToken: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "user_refreshToken")
        }
        get {
            return UserDefaults.standard.string(forKey: "user_refreshToken")
        }
    }

    /// 是否已登录
    static var isLoggedIn: Bool {
        return detailsEntity != nil
    }

    /// 是否已绑定微信
    static var isBoundToWeChat: Bool {
        get {
            return User.detailsEntity?.weixinUnionId.isEmpty == false
        }
        set {
            if newValue == false {
                User.detailsEntity?.weixinUnionId = ""
                User.detailsEntity?.weixinKey = ""
            }
        }
    }
    
    /// 是否已绑定苹果
    static var isBoundToApple: Bool {
        get {
            return User.detailsEntity?.appleName.isEmpty == false
        }
        set {
            if newValue == false {
                User.detailsEntity?.appleName = ""
            }
        }
    }
    
    /// 是否已实名认证
    static var isAuthenticated: Bool {
        set {
            User.detailsEntity?.isAuthenticated = newValue
        }
        get {
            return User.detailsEntity?.isAuthenticated ?? false
        }
    }
}

extension User {
    /// 检查实名认证状态
    /*static func checkAuthenticationStatus(completionHandler: () -> Void) {
        guard User.isLoggedIn else {
            LoginManager.push()
            return
        }
        
        if User.isAuthenticated {
            completionHandler()
        } else {
            let identityVerificationTipsVC = IdentityVerificationTipsViewController()
            Main.currentViewControllerOfNavigation?.pushVC(identityVerificationTipsVC)
        }
    }*/
}

extension User {
    
    // 刷新状态: unRefresh: 未刷新, refreshing: 刷新中, refreshed: 刷新成功
    enum RefreshStyle {
        case unRefresh
        case refreshing
        case refreshed
    }
    
    /// 更新用户详情
    static func updateDetails(with entity: UserDetailsEntity?) {
        self.detailsEntity = entity
        if let entity = entity {
            self.lastPhone = entity.loginName
        }
    }
    
    /// 注销
    static func cancelAccount() {
        entity = nil
        detailsEntity = nil
    }
    
    /// 退出登录
    static func logout() {
        entity = nil
        detailsEntity = nil
        NotificationCenter.default.post(name: .loggedOut, object: nil)
    }
    
    static var isRefreshing: RefreshStyle = .unRefresh {
        didSet {
            if isRefreshing == .refreshed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    isRefreshing = .unRefresh
                }
            }
        }
    }
    
    /// 令牌过期
    static func tokenExpired(successHandler: (() -> Void)? = nil) {
        if isRefreshing == .unRefresh {
            detailsEntity = nil
            token = nil
            isRefreshing = .refreshing
            updateToken {
                isRefreshing = .refreshed
            }
        }
        
        switch isRefreshing {
        case .refreshing: // 刷新中
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                if isRefreshing == .refreshed {
                    print("tokenTest - 刷新成功")
                    successHandler?()
                    timer.invalidate()
                }
            }
        case .refreshed: //刷新成功
            successHandler?()
        default:
            break
        }
    }

    /// 更新令牌
    static func updateToken(onlyUpdate: Bool = false,
                            successHandler: (() -> Void)? = nil,
                            failureHandler: ((Error?) -> Void)? = nil) {
        
        guard let refreshToken = User.refreshToken else {
            failureHandler?(nil)
            return
        }
        let target = LoginAPI.refreshToken(refresh_token: refreshToken)
        NetworkManager.request(target, responseType: .default, successClosure: { (response) in
            if let entity = response.map(UserEntity.self) {
                User.entity = entity
                if !onlyUpdate {
                    getDetails()
                    NotificationCenter.default.post(name: .refreshToken, object: nil)
                }
                successHandler?()
            } else {
                failureHandler?(nil)
            }
        }, retClosure: { (response) in
            failureHandler?(nil)
        }) { (error) in
            failureHandler?(error)
        }
    }
    
    /// 获取用户详情
    static func getDetails(successHandler: (() -> Void)? = nil,
                           failureHandler: ((BaseResponse?) -> Void)? = nil) {
        
        guard let token = User.token else {
            failureHandler?(nil)
            return
        }
        
        NetworkManager.request(UserAPI.detail(token: token), successClosure: { (response) in
            if let entity = response.map(UserDetailsEntity.self) {
                User.updateDetails(with: entity)
                successHandler?()
            } else {
                failureHandler?(response)
            }
        }, retClosure: { (response) in
            failureHandler?(response)
        }) { (error) in
            failureHandler?(nil)
        }
    }
    
    static func getDetails(successHandler: (() -> Void)? = nil,
                           failureHandler: ((BaseResponse?) -> Void)? = nil,
                           errorHandler: ((Error?) -> Void)? = nil) {
        
        guard let token = User.token else {
            failureHandler?(nil)
            return
        }
        
        NetworkManager.request(UserAPI.detail(token: token), successClosure: { (response) in
            if let entity = response.map(UserDetailsEntity.self) {
                User.updateDetails(with: entity)
                successHandler?()
            } else {
                failureHandler?(response)
            }
        }, retClosure: { (response) in
            failureHandler?(response)
        }) { (error) in
            errorHandler?(error)
        }
    }
}
