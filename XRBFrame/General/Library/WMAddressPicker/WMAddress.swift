//
//  AreaModel.swift
//  RefuelNow
//
//  Created by Winson Zhang on 2018/12/19.
//  Copyright © 2018 LY. All rights reserved.
//

import Foundation
import WCDBSwift

struct Province: TableCodable {
    var name: String = ""
    var code: Int = -1
    var level: Int = -1
    var cities: [City] = []

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Province
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name = "name"
        case code = "code"
        case level = "level"
        case cities = "childList"
    }
}

struct City: TableCodable {
    var name: String = ""
    var code: Int = -1
    var level: Int = -1
    var districts: [District] = []

    enum CodingKeys: String, CodingTableKey {
        typealias Root = City
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name = "name"
        case code = "code"
        case level = "level"
        case districts = "childList"
    }
}

struct District: TableCodable {
    var name: String = ""
    var code: Int = -1
    var level: Int = -1
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = District
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name
        case code
        case level
    }
}
