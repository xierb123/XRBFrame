//
//  SearchManager.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/23.
//  历史搜索(本地管理)

import Foundation
import WCDBSwift

struct SearchManager {
    private static let table = DatabaseTable<SearchEntity>(name: .searchHistory)
    
    /// 添加记录
    static func addRecord(_ entity: SearchEntity,
    completionHandler: ((_ isSuccessful: Bool) -> Void)? = nil)  {
        
        DispatchQueue.global().async {
            if entity.searchName.isEmpty{
                DispatchQueue.main.safeAsync {
                    completionHandler?(false)
                }
                return
            }
            table.insertOrReplace(objects: entity)
            DispatchQueue.main.safeAsync {
                completionHandler?(true)
            }
        }
    }
    
    /// 添加多条数据
    static func addRecords(_ entities: [SearchEntity],
    completionHandler: ((_ isSuccessful: Bool) -> Void)? = nil) {
        
        DispatchQueue.global().async {
            var newEntities = entities.filter{ !$0.searchName.isEmpty }
            if newEntities.isEmpty{
                DispatchQueue.main.safeAsync {
                    completionHandler?(false)
                }
                return
            }
            newEntities = newEntities.count > 10 ? Array(newEntities[..<10]) : newEntities
            table.insertOrReplace(objects: newEntities)
            DispatchQueue.main.safeAsync {
                
                completionHandler?(true)
            }
            
        }
    }
    
    /// 移除记录
    static func deleteRecord(_ entity: SearchEntity, completionHandler: (() -> Void)? = nil){
        DispatchQueue.global().async {
            table.delete(where: SearchEntity.Properties.searchName == entity.searchName)
            DispatchQueue.main.safeAsync {
                completionHandler?()
            }
        }
    }
    
    /// 移除多条记录
    static func deleteRecords(_ entities: [SearchEntity], completionHandler:(() -> Void)? = nil){
        DispatchQueue.global().async {
            let historyEntities = entities.filter{ !$0.searchName.isEmpty }
            if historyEntities.isEmpty {
                DispatchQueue.main.safeAsync {
                    completionHandler?()
                }
                return
            }
            let programKeys = historyEntities.map{ $0.searchName }
            table.delete(where: SearchEntity.Properties.searchName.in(programKeys))
            DispatchQueue.main.safeAsync {
                completionHandler?()
            }
        }
    }
    
    /// 获取所有记录
    static func allRecords(completionHandler: @escaping ([SearchEntity]) -> Void){
        DispatchQueue.global().async {
            var entities = table.getObjects()
            if entities.count > 10{
                entities = Array(entities[..<10])
                table.delete()
                table.insert(objects: entities)
            }
            
            DispatchQueue.main.safeAsync {
                completionHandler(entities)
            }
        }
    }
    
    /// 清空所有数据
    static func clearAll(completionHandler:(() -> Void)? = nil){
        DispatchQueue.main.safeAsync {
            table.delete()
            clearHistory()
            completionHandler?()
        }
    }
    
    /// 清除网络记录
    static func clearHistory() {
        /*let target = SearchAPI.clearHistory
        NetworkManager.request(target, successClosure: { (response) in
        }, retClosure: { (response) in
        }) { (error) in
        }*/
    }
}
