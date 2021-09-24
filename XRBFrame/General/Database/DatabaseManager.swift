//
//  DatabaseManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import WCDBSwift

struct DatabaseManager {
    /// 数据库路径
    public static var path: String = {
        return (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "") + "/WCDB/hicon.db"
    }()
    
    /// 检查表是否存在
    static func isTableExists(_ tableName: DatabaseTableName) -> Bool {
        let database = Database(withPath: path)
        var isTableExists: Bool = false
        do {
            isTableExists = try database.isTableExists(tableName.rawValue)
        } catch {
            debugPrint("Database check table exists error: \(error.localizedDescription)")
        }
        return isTableExists
    }

    /// 删除该数据库相关的文件
    static func removeFiles() {
        let database = Database(withPath: path)
        do {
            try database.close(onClosed: {
                try database.removeFiles()
            })
        } catch {
            debugPrint("Database remove files error: \(error.localizedDescription)")
        }
    }
    
    /// 删除表中所有数据
    static func delete(fromTable name: DatabaseTableName) {
        let database = Database(withPath: path)
        do {
            let isTableExists = try database.isTableExists(name.rawValue)
            if isTableExists {
                try database.run(transaction: {
                    try database.delete(fromTable: name.rawValue)
                })
            }
        } catch {
            debugPrint("Database delete from table error: \(error.localizedDescription)")
        }
    }
    
    /// 删除表
    static func drop(table name: DatabaseTableName) {
        let database = Database(withPath: path)
        do {
            try database.drop(table: name.rawValue)
        } catch {
            debugPrint("Database drop table error: \(error.localizedDescription)")
        }
    }
}
