//
//  NetworkManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import Moya

typealias SuccessClosure = (BaseResponse) -> Void
typealias RetClosure = (BaseResponse) -> Void
typealias FailureClosure = (Error?) -> Void

struct NetworkManager {
    /// 请求超时时长
    private static let requestTimeOutInterval: TimeInterval = 20.0

    /// 设置请求头
    private static let endpointClosure = { (target: TargetType) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        let endpoint = Endpoint(url: url,
                                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
        return endpoint
    }

    /// 网络请求的设置
    private static let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = requestTimeOutInterval
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }

    /// Plugin
    private static let networkPlugin = NetworkActivityPlugin { (changeType, targetType) in
        var target = targetType
        if let mutableTarget = target as? MutableTarget {
            target = mutableTarget.target
            if let mutableTarget = target as? MutableTarget {
                target = mutableTarget.target
            }
        }

        switch(changeType){
        case .began:
            print("\(type(of: target)).\(target): network request has began.")
        case .ended:
            print("\(type(of: target)).\(target): network request has ended.")
        }
    }

    /// Provider
    private static let provider = MoyaProvider<MutableTarget>(endpointClosure: endpointClosure,
                                                              requestClosure: requestClosure,
                                                              plugins: [networkPlugin],
                                                              trackInflights: false)
    
    /// Response
    private static func baseResponse(data: Any, type: ResponseType) -> BaseResponse? {
        let baseResponse: BaseResponse?
        switch type {
        case .default:
            baseResponse = DefaultResponse(data: data)
        }
        return baseResponse
    }
}

extension NetworkManager {
    static func request<T: TargetType>(_ target: T,
                                       responseType: ResponseType = .default,
                                       successClosure: SuccessClosure? = nil,
                                       retClosure: RetClosure? = nil,
                                       failureClosure: FailureClosure? = nil) {

        let params = RequestParameterManager.publicParameters(withType: responseType)
        
        func resetRequest() {
            request(target, responseType: responseType, successClosure: successClosure, retClosure: retClosure, failureClosure: failureClosure)
        }
        let mutableTarget = MutableTarget(target, addedParameters: params)

        provider.request(mutableTarget) { result in
            switch result {
            case let .success(response):
                let businessResponse = baseResponse(data: response.data, type: responseType)
                if let response = businessResponse, response.isSuccessfulResponse {
                    if response.isSuccessfulRetcode {
                        successClosure?(response)
                    } else {
                        performPublicBusinessOperations(withRet: response.ret, responseType: responseType) {
                            User.tokenExpired {
                                resetRequest()
                            }
                        }
                        retClosure?(response)
                    }
                } else {
                    failureClosure?(nil)
                }
            case let .failure(error):
                failureClosure?(error)
            }
        }
    }

    static func request<T: TargetType>(_ target: T,
                                       successHandler: @escaping (Data) -> Void,
                                       failureHandler: @escaping (Error) -> Void) {

        let provider = MoyaProvider<T>(endpointClosure: endpointClosure,
                                       requestClosure: requestClosure,
                                       plugins: [networkPlugin],
                                       trackInflights: false)

        provider.request(target) { result in
            switch result {
            case let .success(response):
                successHandler(response.data)
            case let .failure(error):
                failureHandler(error)
            }
        }
    }
}

extension NetworkManager {
    /// 清空cookie
    static func clearCookie(){
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
}
