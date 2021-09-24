//
//  DatabaseTable.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import WCDBSwift

class DatabaseTable<T: TableCodable> {
    private let database: Database
    private let tableName: String
        
    init(name: DatabaseTableName) {
        database = Database(withPath: DatabaseManager.path)
        tableName = name.rawValue
        createTable()
    }

    private func createTable() {
        do {
           try database.run(transaction: {
                do {
                    try database.create(table: tableName, of: T.self)
                } catch {
                    debugPrint("Database create table(\(tableName)) error: \(error.localizedDescription)")
                }
            })
        } catch {
            debugPrint("Database running build table transaction error: \(error.localizedDescription)")
        }
    }
}

extension DatabaseTable {
    /// 插入（单纯的插入数据，当数据出现冲突时会失败）
    ///
    /// - Parameters:
    ///   - objects: 需要插入的对象（可变参数：可以传入一个数组，也可以传入一个或多个对象）
    ///   - propertyConvertibleList: 需要插入的字段
    func insert(objects: T...,
                on propertyConvertibleList: [WCDBSwift.PropertyConvertible]? = nil) {
        
        do {
            try database.insert(objects: objects,
                                on: propertyConvertibleList,
                                intoTable: tableName)
        } catch {
            debugPrint("Database insert objects error: \(error.localizedDescription)")
        }
    }
    
    /// 插入（单纯的插入数据，当数据出现冲突时会失败）
    ///
    /// - Parameters:
    ///   - objects: 需要插入的对象（可变参数：可以传入一个数组，也可以传入一个或多个对象）
    ///   - propertyConvertibleList: 需要插入的字段
    func insert(objects: [T],
                on propertyConvertibleList: [WCDBSwift.PropertyConvertible]? = nil) {
        
        do {
            try database.insert(objects: objects,
                                on: propertyConvertibleList,
                                intoTable: tableName)
        } catch {
            debugPrint("Database insert objects error: \(error.localizedDescription)")
        }
    }
    
    /// 插入（在主键一致时，新数据会覆盖旧数据）
    ///
    /// - Parameters:
    ///   - objects: 需要插入的对象（可变参数：可以传入一个数组，也可以传入一个或多个对象）
    ///   - propertyConvertibleList: 需要插入的字段
    func insertOrReplace(objects: T...,
                         on propertyConvertibleList: [WCDBSwift.PropertyConvertible]? = nil) {
        
        do {
            try database.insertOrReplace(objects: objects,
                                         on: propertyConvertibleList,
                                         intoTable: tableName)
        } catch {
            debugPrint("Database insert or replace objects error: \(error.localizedDescription)")
        }
    }
    
    /// 插入（在主键一致时，新数据会覆盖旧数据）
    ///
    /// - Parameters:
    ///   - objects: 需要插入的对象（可变参数：可以传入一个数组，也可以传入一个或多个对象）
    ///   - propertyConvertibleList: 需要插入的字段
    func insertOrReplace(objects: [T],
                         on propertyConvertibleList: [WCDBSwift.PropertyConvertible]? = nil) {
        
        do {
            try database.insertOrReplace(objects: objects,
                                         on: propertyConvertibleList,
                                         intoTable: tableName)
        } catch {
            debugPrint("Database insert or replace objects error: \(error.localizedDescription)")
        }
    }
    
    /// 更新
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: 需要更新的字段
    ///   - object: 更新所用的对象
    ///   - condition： 符合更新的条件
    ///   - orderList： 排序的方式
    ///   - limit： 更新的个数
    ///   - offset： 从第几个开始更新
    func update(on propertyConvertibleList: WCDBSwift.PropertyConvertible...,
                with object: T,
                where condition: WCDBSwift.Condition? = nil,
                orderBy orderList: [WCDBSwift.OrderBy]? = nil,
                limit: WCDBSwift.Limit? = nil,
                offset: WCDBSwift.Offset? = nil) {

        do {
            try database.update(table: tableName,
                                on: propertyConvertibleList,
                                with: object,
                                where: condition,
                                orderBy: orderList,
                                limit: limit,
                                offset: offset)
        } catch {
            debugPrint("Database update objects error: \(error.localizedDescription)")
        }
    }
         
    /// 查找
    ///
    /// - Parameters:
    ///   - condition： 符合的条件
    ///   - orderList： 排序的方式
    ///   - offset： 第几个
    /// - Returns: 绑定的模型对象
    func getObject(where condition: WCDBSwift.Condition? = nil,
                   orderBy orderList: [WCDBSwift.OrderBy]? = nil,
                   offset: WCDBSwift.Offset? = nil) -> T? {

        var object: T?
        do {
            try object = database.getObject(fromTable: tableName,
                                            where: condition,
                                            orderBy: orderList,
                                            offset: offset)
        } catch {
            debugPrint("Database get object error: \(error.localizedDescription)")
        }
        return object
    }

    /// 查找
    ///
    /// - Parameters:
    ///   - condition： 符合的条件
    ///   - orderList： 排序的方式
    ///   - limit： 查找的个数
    ///   - offset： 从第几个开始
    /// - Returns: 绑定的模型对象数组
    func getObjects(where condition: WCDBSwift.Condition? = nil,
                    orderBy orderList: [WCDBSwift.OrderBy]? = nil,
                    limit: WCDBSwift.Limit? = nil,
                    offset: WCDBSwift.Offset? = nil) -> [T] {
        
        var objects: [T] = []
        do {
            try objects = database.getObjects(fromTable: tableName,
                                              where: condition,
                                              orderBy: orderList,
                                              limit: limit,
                                              offset: offset)
        } catch {
            debugPrint("Database get objects error: \(error.localizedDescription)")
        }
        return objects
    }

    /// 删除
    ///
    /// - Parameters:
    ///   - condition： 符合删除的条件
    ///   - orderList： 排序的方式
    ///   - limit： 删除的个数
    ///   - offset： 从第几个开始删除
    func delete(where condition: WCDBSwift.Condition? = nil,
                orderBy orderList: [WCDBSwift.OrderBy]? = nil,
                limit: WCDBSwift.Limit? = nil,
                offset: WCDBSwift.Offset? = nil) {
        
        do {
            try database.delete(fromTable: tableName,
                                where: condition,
                                orderBy: orderList,
                                limit: limit,
                                offset: offset)
        } catch {
            debugPrint("Database delete objects error: \(error.localizedDescription)")
        }
    }
}

extension DatabaseTable {
    /// 普通事务处理
    /// 事务一般用于提升性能（批量处理）和保证数据原子性
    ///
    /// - Parameters:
    ///   - transaction： 事务处理闭包
    func run(transaction: Core.TransactionClosure) throws {
        try database.run(transaction: transaction)
    }
}
