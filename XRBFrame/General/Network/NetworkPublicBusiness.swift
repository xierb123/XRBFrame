//
//  NetworkPublicBusiness.swift
//  HiconMultiScreen
//
//  Created by devchena on 2021/6/28.
//

import Foundation

extension NetworkManager {
    /// 执行公共业务操作
    static func performPublicBusinessOperations(withRet ret: Int, responseType: ResponseType, failure: (() -> Void)? = nil) {
        let state = UserState.state(with: ret)
        guard User.state != state else {
            if User.state == .tokenExpired {
                print("tokenTest - 状态重复且为token过期")
                failure?()
            }
            return
        }
        
        User.state = state

        switch state {
        case .notLoggedIn:
            break
        case .tokenExpired:
            print("tokenTest - token过期")
            failure?()
        case .onOtherPlatform:
            if User.detailsEntity == nil {
                print("tokenTest - 异地登录")
                failure?()
                return
            }
            Toast.show(Message.onOtherPlatform)
            User.logout()
            
            /*if LiveBroadcastManager.isActive {
                LiveBroadcastManager.performInvalidUserAction(state: .onOtherPlatform)
            } else {
                if !(Main.selectedViewController is PersonalCenterViewController) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        LoginManager.push()
                    }
                }
            }*/
        case .userDisabled, .userLoggedOut:
            let currentVC = Main.currentViewControllerOfNavigation
            if currentVC is LoginViewController {
                return
            }
            
            let message = state == .userDisabled ? Message.userDisabled : Message.userLoggedOut
            Alert.show(message: message, actions: [
                CustomAlertAction(title: "确定", type: .default, handler: {
                    User.logout()
                    NotificationCenter.default.post(name: UserState.stateDidChangeNotificationName,
                                                    object: nil,
                                                    userInfo: [UserState.stateKey: state])
                })
            ])
            return
        default:
            return
        }
        
        NotificationCenter.default.post(name: UserState.stateDidChangeNotificationName,
                                        object: nil,
                                        userInfo: [UserState.stateKey: state])
    }
}
