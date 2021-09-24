//
//  MutableTarget.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import Moya

struct MutableTarget: TargetType {
    /// The embedded `TargetType`.
    var target: TargetType

    /// The added parameters.
    var addedParameters: [String: Any]

    /// Initializes a `MutableTarget`.
    init(_ target: TargetType, addedParameters: [String: Any]) {
        self.target = target
        self.addedParameters = addedParameters
    }

    /// The embedded target's base `URL`.
    var path: String {
        return target.path
    }

    /// The baseURL of the embedded target.
    var baseURL: URL {
        return target.baseURL
    }

    /// The HTTP method of the embedded target.
    var method: Moya.Method {
        return target.method
    }

    /// The sampleData of the embedded target.
    var sampleData: Data {
        return target.sampleData
    }

    /// The `Task` of the embedded target.
    var task: Task {
        switch target.task {
        case .requestParameters(let parameters, let encoding):
            var prarms = parameters
            prarms += addedParameters
            return Task.requestParameters(parameters: prarms.signed, encoding: encoding)
        case .requestCompositeData(let bodyData, let urlParameters):
            var prarms = urlParameters
            prarms += addedParameters
            return Task.requestCompositeData(bodyData: bodyData, urlParameters: prarms.signed)
        case .requestCompositeParameters(let bodyParameters, let bodyEncoding, let urlParameters):
            var prarms = urlParameters
            prarms += addedParameters
            return Task.requestCompositeParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: prarms.signed)
        case .uploadCompositeMultipart(let formDataArray, let urlParameters):
            var prarms = urlParameters
            prarms += addedParameters
            return Task.uploadCompositeMultipart(formDataArray, urlParameters: prarms.signed)
        case .downloadParameters(let parameters, let encoding, let destination):
            var prarms = parameters
            prarms += addedParameters
            return Task.downloadParameters(parameters: prarms.signed, encoding: encoding, destination: destination)
        default:
            return target.task
        }
    }

    /// The `ValidationType` of the embedded target.
    var validationType: ValidationType {
        return target.validationType
    }

    /// The headers of the embedded target.
    var headers: [String: String]? {
        return target.headers
    }
}
