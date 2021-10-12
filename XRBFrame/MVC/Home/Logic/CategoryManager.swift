//
//  CategoryManager.swift
//  BasicProgram
//
//  Created by 谢汝滨 on 2020/9/15.
//  Copyright © 2020 HICON. All rights reserved.
//
//  类目管理器

import Foundation
import WCDBSwift

enum CategoryKey {
    case selectedCategories
    case otherCategories
}

struct CategoryManager {
    private static let selectedTable = DatabaseTable<CategoryEntity>(name: .selectedCategories)
    private static let otherTable = DatabaseTable<CategoryEntity>(name: .otherCategories)
    
    static func  selectedCategories() -> [CategoryEntity] {
        var itemArray = [CategoryEntity]()
        let selectedArr = ["推荐","代码学习","组件封装","音视频","动画效果","设计模式","随笔"]
        for item in selectedArr{
            let entity = CategoryEntity(classifyKey: item, name: item, parentKey: "1111")
            itemArray.append(entity)
        }
        let categoryEntities = allRecords(key: .selectedCategories)
        if categoryEntities.isEmpty {
            addRecords(itemArray, key: .selectedCategories)
            return itemArray
        }
        return categoryEntities
    }
    
    static func otherCategories() -> [CategoryEntity] {
        var itemArray = [CategoryEntity]()
        let selectedArr = ["NBA","视频","汽车","图片","科技","军事","国际","数码","星座","电影","时尚","文化","游戏","教育","动漫","政务","纪录片","房产","佛学","股票","理财","有声","家居","电竞","美容","电视剧","搏击","健康","摄影","生活","旅游","韩流","探索","综艺","美食","育儿"]
        for item in selectedArr{
            let entity = CategoryEntity(classifyKey: item, name: item, parentKey: "1111")
            itemArray.append(entity)
        }
        let categoryEntities = allRecords(key: .otherCategories)
        if categoryEntities.isEmpty {
            addRecords(itemArray, key: .otherCategories)
            return itemArray
        }
        return categoryEntities
    }
}

extension CategoryManager {
    
    /// 添加记录
    static func addRecord(_ entity: CategoryEntity,key: CategoryKey,
    completionHandler: ((_ isSuccessful: Bool) -> Void)? = nil)  {
        func add(){
            DispatchQueue.global().async {
                if entity.name.isEmpty{
                    DispatchQueue.main.safeAsync {
                        completionHandler?(false)
                    }
                    return
                }
                if key == .selectedCategories {
                    selectedTable.insertOrReplace(objects: entity)
                } else {
                    otherTable.insertOrReplace(objects: entity)
                }
                
                DispatchQueue.main.safeAsync {
                    completionHandler?(true)
                }
            }
        }
        /// 搜索去重
        if entity.name.isBlank {
            return
        }
        self.allRecords(key: key) { (entities) in
            entities.forEach { (item) in
                if entity.name == item.name {
                    deleteRecord(entity, key: key) {
                        add()
                        return
                    }
                }
            }
        }
        add()
    }
    
    /// 添加多条数据
    static func addRecords(_ entities: [CategoryEntity], key: CategoryKey,
    completionHandler: ((_ isSuccessful: Bool) -> Void)? = nil) {
        
        DispatchQueue.global().async {
            let newEntities = entities.filter{ !$0.name.isEmpty }
            if newEntities.isEmpty{
                DispatchQueue.main.safeAsync {
                    completionHandler?(false)
                }
                return
            }
            if key == .selectedCategories {
                selectedTable.insertOrReplace(objects: newEntities)
            } else {
                otherTable.insertOrReplace(objects: newEntities)
            }
            
            DispatchQueue.main.safeAsync {
                completionHandler?(true)
            }
        }
    }
    
    /// 移除记录
    static func deleteRecord(_ entity: CategoryEntity, key: CategoryKey, completionHandler: (() -> Void)? = nil){
        DispatchQueue.global().async {
            if key == .selectedCategories {
                selectedTable.delete(where: CategoryEntity.Properties.name == entity.name)
            } else {
                otherTable.delete(where: CategoryEntity.Properties.name == entity.name)
            }
            DispatchQueue.main.safeAsync {
                completionHandler?()
            }
        }
    }
    
    /// 移除全部记录
    static func deleteAllRecords(key: CategoryKey, completionHandler: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            if key == .selectedCategories {
                selectedTable.delete()
            } else {
                otherTable.delete()
            }
            DispatchQueue.main.safeAsync {
                completionHandler?()
            }
        }
    }
    
    
    /// 获取所有记录
    static func allRecords(key: CategoryKey, completionHandler: @escaping ([CategoryEntity]) -> Void){
        DispatchQueue.global().async {
            let entities = key == .selectedCategories ? selectedTable.getObjects() : otherTable.getObjects()
            DispatchQueue.main.safeAsync {
                completionHandler(entities)
            }
        }
    }
    static func allRecords(key: CategoryKey) -> [CategoryEntity]{
        let entities = key == .selectedCategories ? selectedTable.getObjects() : otherTable.getObjects()
        return entities
    }
}
