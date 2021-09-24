//
//  PageContentView.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

public class PageContentView: UIView {
    public weak var eventHandler: PageViewEventHandler?
    public var scrollHandler: ContentScrollHandler?
    
    public var isScrollEnabled: Bool {
        set {
            collectionView.isScrollEnabled = newValue
        }
        get {
            return collectionView.isScrollEnabled
        }
    }

    weak var delegate: PageContentViewDelegate?

    private(set) public var currentIndex: Int
    private(set) public var childViewControllers: [UIViewController]

    private var style: PageStyle
    private var startOffsetX: CGFloat = 0
    private var isForbidDelegate: Bool = false

    private lazy var collectionView: UICollectionView = {
        let layout = PageCollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = style.contentViewBackgroundColor
        collectionView.isScrollEnabled = style.isContentScrollEnabled
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PageContentCell")
        return collectionView
    }()

    public init(frame: CGRect, style: PageStyle, childViewControllers: [UIViewController], currentIndex: Int) {
        self.style = style
        self.childViewControllers = childViewControllers
        self.currentIndex = currentIndex
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.frame = bounds
        if let layout = collectionView.collectionViewLayout as? PageCollectionViewFlowLayout {
            layout.itemSize = bounds.size
            layout.offset = CGFloat(currentIndex) * bounds.size.width
        }
    }

    private func setupView() {
        addSubview(collectionView)
    }
}

public extension PageContentView {
    func appendChildViewControllers(_ viewControllers: [UIViewController]) {
        guard viewControllers.count > 0 else {
            return
        }
        
        // 禁用滑动
        collectionView.isScrollEnabled = false

        // 存储子控制器
        let startRow = childViewControllers.count
        childViewControllers += viewControllers
        
        // 插入items
        var indexPaths: [IndexPath] = []
        for row in startRow..<childViewControllers.count {
            indexPaths.append(IndexPath(row: row, section: 0))
        }
        
        let contentOffset = collectionView.contentOffset
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPaths)
            collectionView.setContentOffset(contentOffset, animated: false)
        }) { [weak self] (finished) in
            guard let self = self else { return }
            self.collectionView.setContentOffset(contentOffset, animated: false)
            self.collectionView.isScrollEnabled = true
        }
    }
}

extension PageContentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageContentCell", for: indexPath)
        return cell
    }
}

extension PageContentView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childViewController = childViewControllers[indexPath.item]
        childViewController.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childViewController.view)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
        NotificationCenter.default.post(name: .homeScrolled, object: nil)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateView(with: scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let isStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if isStop {
                collectionViewDidEndScroll(scrollView)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let isStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if isStop {
            collectionViewDidEndScroll(scrollView)
        }
    }
}

extension PageContentView: PageTitleViewDelegate {
    public func titleView(_ titleView: PageTitleView, didSelectAt index: Int) {
        isForbidDelegate = true
        guard index < childViewControllers.count else {
            return
        }
        
        if index != currentIndex {
            eventHandler?.contentView(self, scrollFrom: currentIndex, to: index)
        }

        currentIndex = index
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        eventHandler?.contentView(self, didEndScrollAt: currentIndex)
    }
}

extension PageContentView {
    private func collectionViewDidEndScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        delegate?.contentView(self, didEndScrollAt: index)

        currentIndex = index
        eventHandler?.contentView(self, didEndScrollAt: currentIndex)
        scrollHandler?(self, index)
    }

    private func updateView(with scrollView: UIScrollView) {
        if isForbidDelegate {
            return
        }
        
        let contentOffsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width
        let remainder = contentOffsetX.truncatingRemainder(dividingBy: scrollViewWidth)
        
        var progress: CGFloat = remainder / scrollViewWidth
        if progress == 0.0 || progress.isNaN {
            return
        }

        var targetIndex: Int = 0
        var sourceIndex: Int = 0
        let index = Int(contentOffsetX / scrollViewWidth)
        
        if contentOffsetX > startOffsetX { // 向右滑动
            sourceIndex = index
            targetIndex = index + 1
            guard targetIndex < childViewControllers.count else {
                return
            }
        } else { // 向左滑动
            sourceIndex = index + 1
            targetIndex = index
            progress = 1 - progress
            if targetIndex < 0 {
                return
            }
        }

        if progress > 0.998 {
            progress = 1
        }

        delegate?.contentView(self, scrollingWith: sourceIndex, targetIndex: targetIndex, progress: progress)
        eventHandler?.contentView(self, scrollingFrom: sourceIndex, to: targetIndex, progress: progress)
    }
}
