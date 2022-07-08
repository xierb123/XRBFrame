//
//  AnimationForPresentListEntity.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/28.
//
//  present转场动画列表数据模型

import Foundation

struct AnimationForPresentListEntity: Codable {
    /// 图片名称
    var imageName: String = ""
    /// 时长
    var time: String = ""
    /// 标题
    var title: String = ""
    /// 用户头像
    var userImage: String = ""
    /// 用户名称
    var userName: String = ""
    /// 收藏次数
    var collectionTime: String = ""
}
