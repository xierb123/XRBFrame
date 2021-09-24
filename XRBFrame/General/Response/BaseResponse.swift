//
//  BaseResponse.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

enum ResponseType {
    case `default`
}

protocol BaseResponse {
    /// 业务码
    var ret: Int { get }
    /// 信息
    var message: String { get }
    /// 数据总数
    var totalCount: Int { get }
    /// 是否没有更多
    var isNoMore: Bool { get }
    /// 数据
    var body: [String: Any]? { get }
    /// 数据列表
    var list: [[String: Any]]? { get }
    /// 成功的响应
    var isSuccessfulResponse: Bool { get }
    /// 成功的业务码
    var isSuccessfulRetcode: Bool { get }
    
    init?(data: Any)
    func map<T: Codable>(_ type: T.Type) -> T?
    func mapArray<T: Codable>(_ type: T.Type) -> [T]?
}

extension BaseResponse {
    var totalCount: Int {
        return 0
    }
    
    var isNoMore: Bool {
        return true
    }
    
    var body: [String: Any]? {
        return nil
    }

    var list: [[String: Any]]? {
        return nil
    }

    func map<T: Codable>(_ type: T.Type) -> T? {
        return nil
    }
    
    func mapArray<T: Codable>(_ type: T.Type) -> [T]? {
        return nil
    }
}
