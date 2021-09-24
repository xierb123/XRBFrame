//
//  AppleAuthManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import AuthenticationServices

class AppleAuthManager: NSObject {
    static let shared = AppleAuthManager()
    
    private var target: UIViewController?
    private var authCompletionHandler: AuthCompletionHandler?

    private override init() {
    }

    @available(iOS 13.0, *)
    func sendAuthRequset(target: UIViewController, completionHandler: @escaping AuthCompletionHandler) {
        self.target = target
        self.authCompletionHandler = completionHandler

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
}

extension AppleAuthManager: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let identityToken = appleIDCredential.identityToken,
                let encodedToken = String(data: identityToken, encoding: .utf8) {
                let userID = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                
                // 用户昵称
                var name = ""
                if let familyName = fullName?.familyName {
                    name += familyName
                }
                if let givenName = fullName?.givenName {
                    name += givenName
                }
                
                let nickname: String? = name.isEmpty ? nil : name
                let appleAuthInfo = AppleAuthInfo(identityToken: encodedToken, userID: userID, nickname: nickname)
                let authInfo = ThirdPartyAuthInfo(type: .apple, appleAuthInfo: appleAuthInfo)
                authCompletionHandler?(authInfo)
            } else {
                Toast.show("已取消授权")
            }
        } else {
            Toast.show("授权失败")
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let authError = error as? ASAuthorizationError {
            let code = authError.code
            switch code {
            case .canceled:
                Toast.show("已取消授权")
            default:
                Toast.show("授权失败")
            }
        }
    }
}

extension AppleAuthManager: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return target?.view.window ?? UIApplication.shared.keyWindow!
    }
}
