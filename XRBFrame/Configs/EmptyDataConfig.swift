//
//  EmptyDataSet.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

protocol EmptyDataSetProtocol {
    var title: NSAttributedString? { get }
    var image: UIImage? { get }
    var buttonImage: UIImage? { get }
    var spaceHeight: CGFloat { get }
    var verticalOffset: CGFloat { get }
    var allowScroll: Bool { get }
}

extension EmptyDataSetProtocol {
    var buttonImage: UIImage? {
        return nil
    }
    
    var spaceHeight: CGFloat {
        return 10.0
    }
    
    var verticalOffset: CGFloat {
        return 0.0
    }

    var allowScroll: Bool {
        return false
    }
}

enum EmptyDataPage {
    /// 默认
    case `default`
    /// 搜索
    case search
    /// 关注(已登录)
    case attentionWithLogin
    /// 关注(未登录)
    case attentionWithoutLogin
    /// 草稿
    case draft
    /// 点播详情页
    case video
}

extension EmptyDataPage: EmptyDataSetProtocol {
    var title: NSAttributedString? {
        var text: String = ""

        switch self {
        case .search:
            text = "没有找到相关内容呢，换个词试试吧"
        case .attentionWithoutLogin:
            text = "请登录后查看"
        case .attentionWithLogin:
            text = "关注的人暂无新动态哦~~"
        case .video:
            text = "暂无评论"
        case .draft:
            text = "暂无草稿"
        default:
            text = "暂无内容"
        }
        
        let font = UIFont.systemFont(ofSize: 14.0)
        let foregroundColor = UIColor(hexString: "#999999")
        let attributedString = NSAttributedString(string: text,
                                                  attributes: [.font: font, .foregroundColor: foregroundColor])
        return attributedString
    }
    
    var image: UIImage? {
        return UIImage(named: "ic_page_empty")
    }
    
    var buttonImage: UIImage? {
        return nil
    }

    var spaceHeight: CGFloat {
        switch self {
        case .search:
            return 18.0
        case .draft:
            return UIDevice.current.isXSeries() ? 24.0 : 12.0
        default:
            return 24.0
        }
    }

    var verticalOffset: CGFloat {
        switch self {
        case .video:
            return 30.0
        case .search:
            return 0.0
        case .draft:
            return 0.0
        default:
            return Constant.screenHeight < 700 ? 0 : -150.0
        }
    }
    
    var allowScroll: Bool {
        return true
    }
}
