//
//  AlertAction.swift
//  HiconMultiScreen
//
//  Created by devchena on 2021/5/10.
//

import Foundation

enum CustomAlertType: Int {
    /// 拉流
    case pullFlow
    /// 直播ID
    case liveId
}

enum CustomAlertActionType: Int {
    case `default`
    case cancel
}

class CustomAlertAction: NSObject {
    typealias ClickHandler = (() -> Void)?
    typealias OutputClickHandler = ((String?) -> Void)?

    /// 按钮标题
    var title: String
    /// 按钮类型
    var type: CustomAlertActionType
    /// 按钮事件
    var handler: ClickHandler?
    var outputHandler: OutputClickHandler?

    init(title: String, type: CustomAlertActionType, handler: ClickHandler? = nil, outputHandler: OutputClickHandler? = nil) {
        self.title = title
        self.type = type
        self.handler = handler
        self.outputHandler = outputHandler
        super.init()
    }
}
