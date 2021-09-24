//
//  LoginAPI.swift
//  HiconTV
//
//  Created by devchena on 2020/3/6.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import Moya

/// 短信验证码 获取类型
enum SmsType:String {
    /// 注册下发验证码
    case rgister = "0"
    /// 找回密码下发验证码
    case findPassword = "1"
    /// 绑定手机号下发验证码
    case bindPhone = "2"
    /// 短信验证码登录
    case codeLogin = "4"
}

enum LoginAPI {
    /// 获取手机短信验证码
    case getSmsCode(phone: String, sendType:String)
    /// 苹果授权登录
    case appleLogin(token: String)
    /// 微信 授权登录
    case wxLogin(type: String, code: String)
    /// QQ 授权登录
    case qqLogin(openid: String, accessToken: String)
    /// 手机号密码登录
    case accountLogin(username: String, password:String)
    /// 验证码校验
    case checkCode(phone: String, code:String)
    /// 设置密码
    case setPassword(phone: String, password:String, verificationCode:String)
    /// 绑定手机号
    case bindPhone(phone: String,type: String)
    /// 苹果绑定手机号
    case appleBindPhone(phone: String, sub: String, nickName: String?)
    /// 刷新令牌
    case refreshToken(refresh_token: String)
    /// 验证码登录
    case codeLogin(phone: String, code:String)
    
}

extension LoginAPI : TargetType {
    var baseURL: URL {
        return AppConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .getSmsCode:
            return "/login/sendVerificationCode"
        case .appleLogin:
            return "/login/appleLogin"
        case .wxLogin:
            return "/login/wxFastLogin"
        case .qqLogin:
            return "/login/qqFastLogin"
        case .accountLogin:
            return "/login/accountLogin"
        case .checkCode:
            return "/login/checkCode"
        case .setPassword:
            return "/login/registerOrChange"
        case .bindPhone:
            return "/user/wxBindLogin"
        case .appleBindPhone:
            return "/user/bindPhoneOnAppleLogin"
        case .refreshToken:
            return "/login/refreshToken"
        case .codeLogin:
            return "/login/codeLogin"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refreshToken:
            return .get
        default:
            return .post
        }
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .getSmsCode(let phone, let sendType):
            params["phone"] = phone
            params["sendType"] = sendType
        case .appleLogin(let token):
            params["token"] = token
        case .wxLogin(let type, let code):
            params["type"] = type
            params["code"] = code
        case .qqLogin(let openid, let accessToken):
            params["openid"] = openid
            params["accessToken"] = accessToken
        case .accountLogin(let username, let password):
            params["username"] = username
            params["password"] = password
        case .checkCode(let phone, let code):
            params["phone"] = phone
            params["code"] = code
        case .setPassword(let phone, let password, let verificationCode):
            params["phone"] = phone
            params["password"] = password
            params["verificationCode"] = verificationCode
        case .bindPhone(let phone,let type):
            params["phone"] = phone
            params["type"] = type
        case .appleBindPhone(let phone, let sub, let nickName):
            params["phone"] = phone
            params["sub"] = sub
            if let nickName = nickName {
                params["nickName"] = nickName
            }
        case .refreshToken(let refresh_token):
            params["refresh_token"] = refresh_token
        case .codeLogin(let phone, let code):
            params["phone"] = phone
            params["code"] = code
        }
        
        let encoding = method == .get ? URLEncoding.default : URLEncoding.httpBody
        return .requestParameters(parameters: params, encoding: encoding)
    }
        
    
    var headers: [String : String]? {
        switch self {
        case .refreshToken:
            return ["Authorization": "Bearer " + (User.token ?? ""), "content-type": "application/json"]
        default:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}
