//
//  PageStyle.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

public struct PageTitleEdgeInsets {
    public var left: CGFloat = 0.0
    public var right: CGFloat = 0.0
}

public struct PageBadgeEdgeInsets {
    public var left: CGFloat = 0.0
    public var top: CGFloat = 0.0
}

public class PageStyle {
    /// 标题视图的高度
    public var titleViewHeight: CGFloat = 44.0
    /// 标题视图距离顶部偏移距离
    public var titleViewTopPadding: CGFloat = 0.0
    /// 标题视图的内间距
    public var titleViewInsets: PageTitleEdgeInsets = .init(left: 15.0, right: 15.0)
    /// 标题视图的圆角
    public var titleViewCornerRadius: CGFloat = 0.0
    /// 标题视图的颜色
    public var titleViewColor: UIColor = UIColor.clear
    /// 标题视图的选中颜色
    public var titleViewSelectedColor: UIColor = UIColor.clear
    /// 标题视图的背景色
    public var titleViewBackgroundColor: UIColor = UIColor.clear
    /// 标题视图是否可滑动（不滑动即为等分模式）
    public var isTitleViewScrollEnabled: Bool = false

    /// 标题间的间距
    public var titleMargin: CGFloat = 30.0
    /// 标题的内边距
    public var titleInsets: UIEdgeInsets = .init(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0)
    /// 标题的字体
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    /// 标题的最大缩放比例因子
    public var titleMaximumScaleFactor: CGFloat = 1.0
    /// 标题的颜色
    public var titleColor: UIColor = UIColor.black
    /// 标题的选中颜色
    public var titleSelectedColor: UIColor = UIColor.blue
    /// 标题是否可缩放
    public var isTitleScaleEnabled: Bool = false
    /// 选中的标题是否可加粗
    public var isSelectedTitleBold: Bool = false
    /// 标题颜色是否渐变
    public var isTitleColorGradient: Bool = false

    /// 是否展示标题的下划线
    public var isShowBottomLine: Bool = false
    /// 标题下划线的颜色
    public var bottomLineColor: UIColor = UIColor.blue
    /// 标题下划线的宽度
    public var bottomLineWidth: CGFloat = 0.0
    /// 标题下划线的高度
    public var bottomLineHeight: CGFloat = 2.0
    /// 标题下划线的圆角
    public var bottomLineCornerRadius: CGFloat = 1.0

    /// 是否展示遮罩
    public var isShowCoverView: Bool = false
    /// 遮罩的背景色
    public var coverViewBackgroundColor: UIColor = UIColor.black
    /// 遮罩的透明度
    public var coverViewAlpha: CGFloat = 0.3
    /// 遮罩左右内边距
    public var coverInset: CGFloat = 8.0
    /// 遮罩的高度
    public var coverViewHeight: CGFloat = 24.0
    /// 遮罩的圆角
    public var coverViewCornerRadius: CGFloat = 12.0

    /// 是否展示右侧渐变遮罩
    public var isShowRightSideMask: Bool = false
    /// 右侧渐变遮罩的宽度
    public var rightSideMaskWidth: CGFloat = 69.0
    /// 右侧渐变遮罩的layer
    public var rightSideMaskLayer: CALayer?
    /// 右侧渐变遮罩的layer颜色
    public var rightSideMaskLayerColor: UIColor = UIColor.white

    /// 内容是否可滚动
    public var isContentScrollEnabled: Bool = true
    /// 内容的背景色
    public var contentViewBackgroundColor = UIColor.white
    
    /// 是否展示泡泡
    public var isShowBubble: Bool = false
    /// 泡泡是否滑动
    public var isBubbleScrollable: Bool = false
    /// 泡泡大小
    public var bubbleSize: CGFloat = 12.0
    /// 泡泡宽度
    public var bubbleWidth: CGFloat = 3.0
    
    
    /// 角标字体
    public var badgeFont: UIFont = UIFont.systemFont(ofSize: 9.0)
    /// 角标颜色
    public var badgeColor: UIColor = UIColor(red: 255.0/255.0, green: 41.0/255.0, blue: 84.0/255.0, alpha: 1.0)
    /// 角标边距
    public var badgeInsets: PageBadgeEdgeInsets = .init(left: 0.0, top: 0.0)

    public init() {}
}
