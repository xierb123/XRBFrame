//
//  DataSource.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import Moya
import WCDBSwift

class DataSource<T: Codable> {
    /// 目标API
    var target: TargetType
    /// 内存缓存过期时间（默认为5分钟）
    var memoryCacheExpirationTime: TimeInterval = 5 * 60
    
    /// 数据模型数组
    private(set) var models: [T] = []
    /// 数据总数
    private(set) var totalCount: Int = 0
    /// 是否没有更多
    private(set) var isNoMore: Bool = true
    /// 是否正在刷新
    private(set) var isRefreshing: Bool = false
    /// 是否正在加载更多
    private(set) var isLoadingMore: Bool = false
    
    /// 分页步长
    let step: Int
    /// 当前页码
    private(set) var pageNumber: Int = 1
    
    /// 本地缓存选项
    private var diskCacheOptions: DiskCacheOptions?
    /// 响应类型
    private var responseType: ResponseType = .default
    /// 上次更新日期
    private var lastUpdateDate: Date?

    private lazy var table = DatabaseTable<DataSourceObject>(name: .dataSource)

    /// 初始化数据源
    ///
    /// - Parameters:
    ///   - target: 目标API
    ///   - step: 分页步长
    ///   - storageOptions: 本地缓存选项（优先从数据库获取目标数据）
    init(target: TargetType,
         responseType: ResponseType = .default,
         step: Int = 18,
         diskCacheOptions: DiskCacheOptions? = nil) {

        self.target = target
        self.responseType = responseType
        self.step = step
        self.diskCacheOptions = diskCacheOptions
        self.getDiskStorage()
    }
    
    /// 获取本地存储
    private func getDiskStorage() {
        guard let diskCacheOptions = self.diskCacheOptions else {
            return
        }
        
        // 获取本地存储
        let condition = DataSourceObject.Properties.identifier == diskCacheOptions.key
        guard let object = table.getObject(where: condition) else {
            return
        }
        
        // 如果本地存储过期则执行删除操作
        let createTime = object.createTime
        switch diskCacheOptions.expiry {
        case .seconds(let timeInterval):
            if Date().timeIntervalSince(createTime) >= timeInterval {
                table.delete(where: condition)
                return
            }
        case .date(let date):
            if Date() >= date {
                table.delete(where: condition)
                return
            }
        case .never:
            break
        }

        // 对有效的数据进行数据模型转换
        guard let data = object.data, let models = try? Mapper<T>.mapArray(data: data) else {
            return
        }
        self.totalCount = object.totalCount
        self.isNoMore = object.isNoMore
        self.lastUpdateDate = object.createTime
        self.models = models
    }
}

extension DataSource {
    /// 模型数量
    var modelCount: Int {
        return models.count
    }

    /// 数据是否为空
    var isEmpty: Bool {
        return models.isEmpty
    }

    /// 内存缓存是否过期
    var isMemoryCacheExpired: Bool {
        guard let date = lastUpdateDate else {
            return true
        }
        return Date().timeIntervalSince(date) > memoryCacheExpirationTime
    }
}

extension DataSource {
    /// 更新target
    func update(target: TargetType) {
        self.target = target
    }
    
    /// 插入数据
    func insertModel(_ model: T, at index: Int) {
        models.insert(model, at: index)
        storageModel()
    }
    
    /// 移除数据
    func removeModel(at index: Int) {
        guard index < models.count else {
            return
        }
        models.remove(at: index)
        storageModel()
    }
    
    /// 移除全部数据
    func removeAll() {
        models.removeAll()
        storageModel()
    }
    
    /// 添加数据
    func addModel(model: T) {
        insertModel(model, at: 0)
    }
}

extension DataSource {
    /// 刷新数据
    ///
    /// - Parameters:
    ///   - isPagingIgnored: 是否忽略分页（默认为false）
    func refresh(isPagingIgnored: Bool = false,
                 successClosure: @escaping ([T]) -> Void,
                 retClosure: @escaping (_ ret: Int, _ message: String) -> Void,
                 failureClosure: @escaping (Swift.Error?) -> Void) {

        isRefreshing = true
        pageNumber = 1
        
        let params: [String: String] = isPagingIgnored ? [:] : ["offset": String(pageNumber), "pageSize": String(step)]
        let mutableTarget = MutableTarget(target, addedParameters: params)
        NetworkManager.request(mutableTarget, responseType: self.responseType, successClosure: { [weak self] (response) in
            guard let self = self else { return }
            self.isRefreshing = false
            self.lastUpdateDate = Date()
            self.totalCount = response.totalCount
            self.isNoMore = response.isNoMore
            
            // 数模转换
            self.models = []
            if let list = response.list, list.isEmpty == false {
                self.models = (try? Mapper<T>.mapArray(jsonArray: list)) ?? []
            }
            
            // 存储数据到本地
            self.storageModel()
            
            successClosure(self.models)
        }, retClosure: { [weak self] (response) in
            guard let self = self else { return }
            self.isRefreshing = false
            retClosure(response.ret, response.message)
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.isRefreshing = false
            failureClosure(error)
        }
    }

    /// 加载更多
    func loadMore(successClosure: @escaping ([T]) -> Void,
                  retClosure: @escaping (_ ret: Int, _ message: String) -> Void,
                  failureClosure: @escaping (Swift.Error?) -> Void) {

        isLoadingMore = true
        pageNumber += 1

        let params: [String: String] = ["offset": String(pageNumber), "pageSize": String(step)]
        let mutableTarget = MutableTarget(target, addedParameters: params)

        NetworkManager.request(mutableTarget, responseType: responseType, successClosure: { [weak self] (response) in
            guard let self = self else { return }
            self.isLoadingMore = false
            self.lastUpdateDate = Date()
            self.totalCount = response.totalCount
            self.isNoMore = response.isNoMore

            // 数模转换
            if let list = response.list, list.isEmpty == false {
                self.models += (try? Mapper<T>.mapArray(jsonArray: list)) ?? []
            }

            // 存储数据到本地
            self.storageModel()

            successClosure(self.models)
        }, retClosure: { [weak self] (response) in
            guard let self = self else { return }
            self.isLoadingMore = false
            retClosure(response.ret, response.message)
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.isLoadingMore = false
            failureClosure(error)
        }
    }
}

extension DataSource {
    /// 存储数据
    private func storageModel() {
        guard let cacheKey = diskCacheOptions?.key else {
            return
        }

        DispatchQueue.global().async {
            guard let data = try? self.models.toData() else {
                return
            }

            let object = DataSourceObject()
            object.identifier = cacheKey
            object.data = data
            object.totalCount = self.totalCount
            object.isNoMore = self.isNoMore
            self.table.insertOrReplace(objects: object)
        }
    }
}
