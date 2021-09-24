//
//  PageViewManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

public class PageViewManager: NSObject {
    public weak var eventHandler: PageViewEventHandler? {
        didSet {
            titleView.eventHandler = eventHandler
            contentView.eventHandler = eventHandler
        }
    }
    
    public var currentIndex: Int {
        return contentView.currentIndex
    }
    
    public var isScrollEnabled: Bool {
        set {
            titleView.isScrollEnabled = newValue
            contentView.isScrollEnabled = newValue
        }
        get {
            return contentView.isScrollEnabled
        }
    }

    private(set) public var titles: [String]
    private(set) public var childViewControllers: [UIViewController]
    private(set) public lazy var titleView = PageTitleView(frame: .zero, style: style, titles: titles, currentIndex: startIndex)
    private(set) public lazy var contentView = PageContentView(frame: .zero, style: style, childViewControllers: childViewControllers, currentIndex: startIndex)

    private var style: PageStyle
    private var startIndex: Int

    public init(style: PageStyle, titles: [String], childViewControllers: [UIViewController], startIndex: Int = 0) {
        self.style = style
        self.titles = titles
        self.childViewControllers = childViewControllers
        self.startIndex = startIndex
        super.init()
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}

public extension PageViewManager {
    /// 选中指定页面
    func select(atIndex index: Int) {
        contentView.titleView(titleView, didSelectAt: index)
        titleView.contentView(contentView, didEndScrollAt: index)
    }

    /// 添加新页面
    func append(titles: [String], childViewControllers: [UIViewController]) {
        if titles.count != childViewControllers.count {
            print("PageViewManager: the titles cannot match the view controllers.")
            return
        }
        titleView.appendTitles(titles)
        contentView.appendChildViewControllers(childViewControllers)
    }
    
    /// 更新标题
    func updateTitle(_ title: String, at index: Int) {
        titleView.updateTitle(title, at: index)
    }
    
    /// 更新所有标题
    func updateTitles(_ titles: [String]) {
        if titles.count != childViewControllers.count {
            print("PageViewManager: the titles can't match the view controllers.")
            return
        }
        titleView.updateTitles(titles)
    }

    /// 设置角标
    func setBadge(value: String?, at index: Int) {
        titleView.setBadge(value: value, at: index)
    }
}
