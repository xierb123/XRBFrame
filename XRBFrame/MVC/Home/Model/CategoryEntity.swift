//
//  CategoryEntity.swift
//  HiconTV
//
//  Created by devchena on 2020/2/24.
//  Copyright © 2020 HICON. All rights reserved.
//
//  分类数据模型

import Foundation
import WCDBSwift

struct CategoryEntity: TableCodable, Equatable {
    /// 分类id
    var classifyKey = ""
    /// 分类名称
    var name = ""
    /// 父类id
    var parentKey = ""
    
    enum CodingKeys: String, CodingTableKey{
        typealias Root = CategoryEntity
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case classifyKey
        case name
        case parentKey
        
        static var  columnConstraintBindings: [CodingKeys : ColumnConstraintBinding]? {
            return [
                name: ColumnConstraintBinding(isPrimary: true)
            ]
        }
    }
    
    static func ==(lhs: CategoryEntity, rhs:CategoryEntity) -> Bool {
        return lhs.name == rhs.name && lhs.classifyKey == rhs.classifyKey
    }
}

