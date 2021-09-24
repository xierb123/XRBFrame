//
//  SearchEntity.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/23.
//
//  热门搜索数据模型

import Foundation
import WCDBSwift

struct SearchEntity: TableCodable, Equatable {
    /// 搜索节目Id
    var videoId: String = ""
    /// 历史搜索标题
    var searchName: String = ""
    /// 主键(videoName或searchName的非空值)
    var titleStr:String = ""
    /// 创建时间
    var createTime: String = Date().milliStamp
    
    init(videoId: String, searchName: String, titleStr: String, createTime: String){
        self.videoId = videoId
        self.searchName = searchName
        self.titleStr = titleStr
        self.createTime = createTime
    }
    init(searchName: String) {
        self.init(videoId: "videoId", searchName: searchName, titleStr: "titleStr", createTime: "createTime")
    }
    
    enum CodingKeys: String, CodingTableKey{
        typealias Root = SearchEntity
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case videoId
        case searchName
        case titleStr
        case createTime
        
        static var  columnConstraintBindings: [CodingKeys : ColumnConstraintBinding]? {
            return [
                // 主键
                searchName: ColumnConstraintBinding(isPrimary: true)
            ]
        }
    }
    
    static func ==(lhs: SearchEntity, rhs:SearchEntity) -> Bool {
        return lhs.videoId == rhs.videoId && lhs.searchName == rhs.searchName
    }
}
