//
//  PageHelper.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

typealias ColorRGB = (red: CGFloat, green: CGFloat, blue: CGFloat)

public typealias TitleClickHandler = (PageTitleView, Int) -> ()
public typealias ContentScrollHandler = (PageContentView, Int) -> ()

public protocol PageTitleViewDelegate: AnyObject {
    func titleView(_ titleView: PageTitleView, didSelectAt index: Int)
}

public protocol PageContentViewDelegate: AnyObject {
    func contentView(_ contentView: PageContentView, didEndScrollAt index: Int)
    func contentView(_ contentView: PageContentView, scrollingWith sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

public extension PageContentViewDelegate {
    func contentView(_ contentView: PageContentView, didEndScrollAt index: Int) {}
    func contentView(_ contentView: PageContentView, scrollingWith sourceIndex: Int, targetIndex: Int, progress: CGFloat) {}
}

public protocol PageViewEventHandler: AnyObject {
    func titleView(_ titleView: PageTitleView, didSelectTitleAt index: Int, isSame: Bool)
    func titleView(_ titleView: PageTitleView, didEndScrollAt index: Int)
    func titleView(_ titleView: PageTitleView, scrollFrom index: Int, to targetIndex: Int)
    func contentView(_ contentView: PageContentView, didEndScrollAt index: Int)
    func contentView(_ contentView: PageContentView, scrollFrom index: Int, to targetIndex: Int)
    func contentView(_ contentView: PageContentView, scrollingFrom index: Int, to targetIndex: Int, progress: CGFloat)
}

public extension PageViewEventHandler {
    func titleView(_ titleView: PageTitleView, didSelectTitleAt index: Int, isSame: Bool) {}
    func titleView(_ titleView: PageTitleView, didEndScrollAt index: Int) {}
    func titleView(_ titleView: PageTitleView, scrollFrom index: Int, to targetIndex: Int) {}
    func contentView(_ contentView: PageContentView, didEndScrollAt index: Int) {}
    func contentView(_ contentView: PageContentView, scrollFrom index: Int, to targetIndex: Int) {}
    func contentView(_ contentView: PageContentView, scrollingFrom index: Int, to targetIndex: Int, progress: CGFloat) {}
}
