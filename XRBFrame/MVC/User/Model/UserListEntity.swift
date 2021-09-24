//
//  UserListEntity.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/12.
//

import Foundation

struct UserListEntity: Codable {
    /// 主标题
    var title: String = ""
    /// 副标题
    var subTitle: String = ""
    
    init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
}

