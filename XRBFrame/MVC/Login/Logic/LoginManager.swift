//
//  LoginManager.swift
//  HiconTV
//
//  Created by devchena on 2020/3/7.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

struct LoginManager {
    private static var lastPushTime: Date?
        
    /// 去登陆
    static func push(parent: UIViewController? = nil) {
        func pushLoginVC() {
            lastPushTime = Date()
            DispatchQueue.main.async {
                if Main.currentViewControllerOfNavigation is LoginViewController {
                    return
                }
                let loginVC = LoginViewController()
                (parent ?? Main.currentViewControllerOfNavigation)?.pushVC(loginVC)
            }
        }
        
        if let time = lastPushTime {
            if Date().secondsSince(time) >= 1.0 {
                pushLoginVC()
            }
        } else {
            pushLoginVC()
        }
    }
    
    /// 手机号密码登录
    static func accountLogin(phone: String,
                             password: String,
                             targetViewController: UIViewController,
                             successHandler: (() -> Void)? = nil) {
        
        guard NetworkReachabilityMonitor.isReachable else {
            Toast.show(Message.noNetwork)
            return
        }
        guard let view = targetViewController.view else {
            return
        }
        
        view.showLoading(style: .clear)
        let target = LoginAPI.accountLogin(username: phone, password: password)

        NetworkManager.request(target, responseType: .default, successClosure: { (response) in
            view.hideLoading()
            if let entity = response.map(UserEntity.self) {
                User.entity = entity
                User.getDetails(successHandler: {
                    Toast.show(Message.loginSuccessful)
                    NotificationCenter.default.post(name: .loginSuccessful, object: nil)
                    successHandler?()
                }) { (response) in
                    User.entity = nil
                    if let message = response?.message {
                        Toast.show(message)
                    } else {
                        Toast.show(Message.loginFailed)
                    }
                }
            } else {
                Toast.show(Message.loginFailed)
            }
        }, retClosure: { (response) in
            view.hideLoading()
            Toast.show(response.message)
        }) { (error) in
            view.hideLoading()
            Toast.show(Message.networkException)
        }
    }
    
    /// 验证码登录
    static func codeLogin(phone: String,
                          code: String,
                          targetViewController: UIViewController,
                          successHandler: (() -> Void)? = nil,
                          failedHandler: (() -> Void)? = nil) {
        guard NetworkReachabilityMonitor.isReachable else {
            Toast.show(Message.noNetwork)
            return
        }
        guard let view = targetViewController.view else {
            return
        }
        
        view.showLoading(style: .clear, layoutClosure: nil)
        let target = LoginAPI.codeLogin(phone: phone, code: code)
        
        NetworkManager.request(target, responseType: .default, successClosure: { (response) in
            view.hideLoading()
            if let entity = response.map(UserEntity.self) {
                User.entity = entity
                User.getDetails(successHandler: {
                    Toast.show(Message.loginSuccessful)
                    NotificationCenter.default.post(name: .loginSuccessful, object: nil)
                    successHandler?()
                }) { (response) in
                    User.entity = nil
                    if let message = response?.message {
                        Toast.show(message)
                    } else {
                        Toast.show(Message.loginFailed)
                    }
                }
            } else {
                Toast.show(Message.loginFailed)
            }
        }, retClosure: { (response) in
            view.hideLoading()
            Toast.show(response.message)
            failedHandler?()
        }) { (error) in
            view.hideLoading()
            Toast.show(Message.networkException)
        }
    }

    /// 第三方登录
    static func thirdParyLogin(authInfo: ThirdPartyAuthInfo,
                               targetViewController: UIViewController,
                               successHandler: (() -> Void)? = nil,
                               unboundHandler: ((_ type: ThirdPartyAuthInfo) -> Void)? = nil) {
        
        guard NetworkReachabilityMonitor.isReachable else {
            Toast.show(Message.noNetwork)
            return
        }
        guard let view = targetViewController.view else {
            return
        }
        
        view.showLoading(style: .clear)
        let target: LoginAPI
        if authInfo.type == .wechat  {
            target = LoginAPI.wxLogin(type: "1", code: authInfo.code) // (code: authInfo.code)
        } else if authInfo.type == .qq {
            target = LoginAPI.qqLogin(openid: authInfo.code, accessToken: authInfo.accessToken ?? "")
        } else {
            target = LoginAPI.appleLogin(token: authInfo.appleAuthInfo?.identityToken ?? "") // (identityToken: authInfo.identityToken)
        }

        NetworkManager.request(target, responseType: .default, successClosure: { (response) in
            view.hideLoading()
            // userType：1是授权用户，2是注册用户
            /*guard let userType = (response as? UserCenterResponse)?.userType else {
                return
            }
            guard userType == 1 || userType == 2 else {
                return
            }*/
            
            if let entity = response.map(UserEntity.self) {
                //if userType == 2 {
                    User.entity = entity
                    User.getDetails(successHandler: {
                        Toast.show(Message.loginSuccessful)
                        NotificationCenter.default.post(name: .loginSuccessful, object: nil)
                        successHandler?()
                    }) { (response) in
                        if let message = response?.message, let ret = response?.ret {
                            Toast.show(message)
                            if ret == 402 {
                                unboundHandler?(authInfo)
                            } else {
                                User.entity = nil
                            }
                        } else {
                            Toast.show(Message.loginFailed)
                        }
                    }
                /*} else {
                    unboundHandler?(entity.access_token)
                }*/
            } else {
                Toast.show(Message.loginFailed)
            }
        }, retClosure: { (response) in
            view.hideLoading()
            
            Toast.show(response.message)
        }) { (error) in
            view.hideLoading()
            
            Toast.show(Message.networkException)
        }
    }
}

