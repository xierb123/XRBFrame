//
//  DataSourceObject.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import WCDBSwift

class DataSourceObject: TableCodable {
    var identifier: String?
    var data: Data?
    var totalCount: Int = 0
    var isNoMore: Bool = true
    var createTime: Date = Date()

    enum CodingKeys: String, CodingTableKey {
        typealias Root = DataSourceObject
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case data
        case totalCount
        case createTime
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(isPrimary: true)
            ]
        }
    }
}
