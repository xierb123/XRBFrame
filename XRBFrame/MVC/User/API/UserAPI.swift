//
//  UserAPI.swift
//  HiconTV
//
//  Created by devchena on 2020/3/21.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import Moya

enum UserAPI {
    /// 获取用户详情
    case detail(token: String)
    /// 用户关注操作
    case userAttention(userId: String, attentionType:String)
    /// 获取用户列表
    case userList(searchWord:String?, customKey: String?, type:String?, requestType:String)
    /// 获取消息读取情况
    case getMessageInfo
    /// 获取登录用户信息
    case getLoginUserInfo(token: String)
    /// 获取用户基本信息
    case getCustomerInfo(customerKey: String? = nil)
    /// 编辑个人资料
    case updateCustomerInfo(customerImg: String?, customerName: String?, sex: Int?, birthday: String?, provinceId: String?, cityId: String?, countyId: String?, description: String?)
    /// 上传用户头像
    case uploadAvatar(data: Data)
    /// 账号注销
    case userLogout(token: String)
    /// 用户协议 / 隐私政策 / 关于我们 / 注销须知
    case agreement(type: Int)
}

extension UserAPI : TargetType {
    var baseURL: URL {
        return AppConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .userAttention:
            return "/customer/attention"
        case .detail:
            return "/user/getLoginUserInfo"
        case .userList:
            return "/customer/getCustomerList"
        case .getMessageInfo:
            return "message/read_info"
        case .getLoginUserInfo:
            return "/user/getLoginUserInfo"
        case .getCustomerInfo:
            return "/customer/getCustomerInfo"
        case .updateCustomerInfo:
            return "/customer/updateCustomerInfo"
        case .uploadAvatar:
            return "/common/upload_image"
        case .userLogout:
            return "/user/logout"
        case .agreement:
            return "/setting/getContent"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateCustomerInfo, .uploadAvatar:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        var formDataArray: [MultipartFormData] = []
        
        switch self {
        case .userAttention(let userID, let attentionType):
            params["userId"] = userID
            params["attentionType"] = attentionType
        case .detail(let token):
            params["token"] = token
        case .userList(let searchWord, let customKey, let type, let requestType):
            params["requestType"] = requestType
            if let searchWord = searchWord {
                params["searchWord"] = searchWord
            }
            if let customKey = customKey {
                params["customKey"] = customKey
            }
            if let type = type {
                params["type"] = type
            }
        case .getLoginUserInfo(let token):
            params["token"] = token
        case .getCustomerInfo(let customerKey):
            params["customerKey"] = customerKey ?? User.detailsEntity?.customerKey
        case .updateCustomerInfo(customerImg: let customerImg, customerName: let customerName, sex: let sex, birthday: let birthday, provinceId: let provinceId, cityId: let cityId, countyId: let countyId, description: let description):
            if let customerImg = customerImg {
                params["customerImg"] = customerImg
            }
            if let customerName = customerName  {
                params["customerName"] = customerName
            }
            if let sex = sex {
                params["sex"] = sex
            }
            if let birthday = birthday {
                params["birthday"] = birthday
            }
            if let provinceId = provinceId, let cityId = cityId, let countyId = countyId {
                params["provinceId"] = provinceId
                params["cityId"] = cityId
                params["countyId"] = countyId
            }
            if let description = description {
                params["description"] = description
            }
        case .uploadAvatar(let data):
            params["path"] = "head"
            params["limitSize"] = 0

            let date = Date().milliStamp
            let fileName = "image\(date).png"
            let formData = MultipartFormData(provider: .data(data), name: "file", fileName: fileName, mimeType: "image/jpeg")
            formDataArray.append(formData)
        case .userLogout(let token):
            params["token"] = token
        case .agreement(let type):
            params["type"] = type
        default:
            break
        }
        
        switch self {
        case .uploadAvatar:
            return .uploadCompositeMultipart(formDataArray, urlParameters: params)
        default:
            let encoding = method == .get ? URLEncoding.default : URLEncoding.httpBody
            return .requestParameters(parameters: params, encoding: encoding)
        }
    }
}
