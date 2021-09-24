//
//  PageTitleView.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

public class PageTitleView: UIView {
    public weak var eventHandler: PageViewEventHandler?
    public var clickHandler: TitleClickHandler?

    public var isScrollEnabled: Bool {
        set {
            scrollView.isScrollEnabled = newValue
        }
        get {
            return scrollView.isScrollEnabled
        }
    }
    
    weak var delegate: PageTitleViewDelegate?

    private(set) public var titles: [String]
    private(set) public var currentIndex: Int

    private var style: PageStyle
    private lazy var titleViews: [UIView] = []
    private lazy var titleLabels: [UILabel] = []

    private var hasLayout: Bool = false

    private lazy var normalRGB: ColorRGB = self.style.titleColor.rgb
    private lazy var normalAlpha: CGFloat = self.style.titleColor.alpha
    private lazy var selectRGB: ColorRGB = self.style.titleSelectedColor.rgb
    private lazy var selectAlpha: CGFloat = self.style.titleSelectedColor.alpha
    private lazy var deltaRGB: ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()
    private lazy var deltaAlpha: CGFloat = {
        let deltaA = self.selectAlpha - self.normalAlpha
        return deltaA
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = style.titleViewBackgroundColor
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()

    private lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = style.bottomLineColor
        bottomLine.layer.cornerRadius = style.bottomLineCornerRadius
        bottomLine.layer.masksToBounds = true
        return bottomLine
    }()

    private lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = style.coverViewBackgroundColor
        coverView.alpha = style.coverViewAlpha
        return coverView
    }()

    private lazy var rightSideMask: UIView = {
        let mask = UIView()
        return mask
    }()
    
    private lazy var bubble: UIImageView = {
        let frame = CGRect(x: -30, y: -30, width: style.bubbleSize, height: style.bubbleSize)
        let bubble = UIImageView(frame: frame)
        bubble.layer.cornerRadius = style.bubbleSize/2
        bubble.layer.borderColor = UIColor(hexString: "#FF4516").cgColor
        bubble.layer.borderWidth = style.bubbleWidth
        return bubble
    }()

    public init(frame: CGRect, style: PageStyle, titles: [String], currentIndex: Int) {
        self.style = style
        self.titles = titles
        self.currentIndex = currentIndex
        super.init(frame: frame)
        setupView()
        addObserver()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != .zero, !hasLayout {
            hasLayout = true
            scrollView.frame = bounds
            setupSubViewsLayout()
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateSubviewsLayout(_:)),
                                               name: .dismissToRootVC, object: nil)
    }
    
    @objc private func updateSubviewsLayout(_ notification: Notification) {
        setupBottomLineLayout()
    }
}

public extension PageTitleView {
    /// 添加标题项
    func appendTitles(_ titles: [String]) {
        guard !titles.isEmpty else {
            return
        }

        let startIndex = self.titles.count
        self.titles += titles

        for (i, title) in titles.enumerated() {
            let index = startIndex + i
            let titleViewFrame = self.titleViewFrame(at: index)
            let titleView = initTitleView(at: index)
            titleView.frame = titleViewFrame
            scrollView.addSubview(titleView)

            let titleLabel = initTitleLabel(with: title, at: index)
            titleLabel.frame = CGRect(origin: .zero, size: titleViewFrame.size)
            titleView.addSubview(titleLabel)
            
            titleViews.append(titleView)
            titleLabels.append(titleLabel)
        }

        if style.isTitleViewScrollEnabled {
            adjustContentSize()
            adjustTitleViewPosition(at: currentIndex)
        }
    }
    
    /// 更新标题
    func updateTitle(_ title: String, at index: Int) {
        guard index >= 0, index < titles.count, index < titleLabels.count else {
            return
        }
        
        titles[index] = title
        titleLabels[index].text = title
        if style.isTitleViewScrollEnabled{
            updateTitles(titles)
        }
        adjustBadgePosition(at: index)
    }

    /// 更新所有标题
    func updateTitles(_ titles: [String]) {
        guard !titles.isEmpty else {
            return
        }

        scrollView.removeSubviews()
        self.titles = titles

        for (i, title) in titles.enumerated() {
            let titleViewFrame = self.titleViewFrame(at: i)
            let titleView = UIView(frame: titleViewFrame)
            scrollView.addSubview(titleView)
            setupBottomLine()

            let titleLabel = initTitleLabel(with: title, at: i)
            titleLabel.frame = CGRect(origin: .zero, size: titleViewFrame.size)
            titleView.addSubview(titleLabel)
            
            titleViews[i] = titleView
            titleLabels[i] = titleLabel
        }

        if style.isTitleViewScrollEnabled {
            adjustContentSize()
            adjustTitleViewPosition(at: currentIndex)
        }
    }
        
    /// 设置角标
    func setBadge(value: String?, at index: Int) {
        guard index >= 0, index < titleViews.count else {
            return
        }
                                
        let titleView = titleViews[index]
        let badgeView = titleView.subviews.filter { $0.isKind(of: PageBadgeView.self) }.first as? PageBadgeView
        
        if let string = value, string.isEmpty {
            badgeView?.removeFromSuperview()
        } else {
            if let badgeView = badgeView {
                badgeView.badgeValue = value
                badgeView.setNeedsLayout()
            } else {
                let badgeView = PageBadgeView()
                badgeView.badgeLabel.font = style.badgeFont
                badgeView.badgeColor = style.badgeColor
                badgeView.badgeValue = value
                titleView.addSubview(badgeView)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.adjustBadgePosition(at: index)
                }
            }
        }
     }
}

extension PageTitleView {
    private func setupView() {
        addSubview(scrollView)

        setupTitleViews()
        setupBottomLine()
        setupCoverView()
        setupRightSideMask()
        setupBubble()
    }

    private func setupTitleViews() {
        for (index, title) in titles.enumerated() {
            let titleView = initTitleView(at: index)
            scrollView.addSubview(titleView)

            let titleLabel = initTitleLabel(with: title, at: index)
            titleView.addSubview(titleLabel)
            
            titleViews.append(titleView)
            titleLabels.append(titleLabel)
        }
    }

    private func setupBottomLine() {
        guard style.isShowBottomLine else {
            return
        }
        scrollView.addSubview(bottomLine)
    }

    private func setupCoverView() {
        guard style.isShowCoverView else {
            return
        }
        scrollView.insertSubview(coverView, at: 0)
        coverView.layer.cornerRadius = style.coverViewCornerRadius
        coverView.layer.masksToBounds = true
    }
    
    private func setupRightSideMask() {
        guard style.isShowRightSideMask else {
            return
        }
        guard style.rightSideMaskWidth > 0.0 else {
            return
        }
        insertSubview(rightSideMask, aboveSubview: scrollView)
    }
    
    private func setupBubble() {
        guard style.isShowBubble else {
            return
        }
        scrollView.addSubview(bubble)
    }
}

extension PageTitleView {
    private func initTitleView(at index: Int) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = style.titleViewCornerRadius
        view.backgroundColor = index == currentIndex ? style.titleViewSelectedColor : style.titleViewColor
        return view
    }

    private func initTitleLabel(with title: String, at index: Int) -> UILabel {
        let label = UILabel()
        label.tag = index
        label.text = title
        label.font = style.titleFont
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.textColor = index == currentIndex ? style.titleSelectedColor : style.titleColor
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTitleLabel(_:)))
        label.addGestureRecognizer(tapGestureRecognizer)
        
        return label
    }
    
    private func titleViewFrame(at index: Int) -> CGRect {
        var x: CGFloat = 0.0
        let y: CGFloat = style.titleViewTopPadding
        var width: CGFloat = 0.0
        var height = frame.size.height - style.titleViewTopPadding

        if style.isTitleViewScrollEnabled {
            let size = titleSize(at: index)
            width = size.width + style.titleInsets.left + style.titleInsets.right
            height = size.height + style.titleInsets.top + style.titleInsets.bottom
        } else {
            let count = titles.count
            width = (frame.width - style.titleViewInsets.left - style.titleViewInsets.right - CGFloat(count - 1) * style.titleMargin) / CGFloat(count)
        }
        
        if index == 0 {
            x = style.titleViewInsets.left
        } else {
            x = titleViews[index - 1].frame.maxX + style.titleMargin
        }

        return CGRect(x: x, y: y, width: width, height: height)
    }

    private func titleSize(at index: Int) -> CGSize {
        let font = style.isSelectedTitleBold ? UIFont.boldSystemFont(ofSize: style.titleFont.pointSize) : style.titleFont
        let bounds = titles[index].boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0.0),
                                               options: .usesLineFragmentOrigin,
                                               attributes: [.font: font], context: nil)
        return bounds.size
    }
}

extension PageTitleView {
    private func setupSubViewsLayout() {
        setupTitleViewsLayout()
        setupBottomLineLayout()
        setupCoverViewLayout()
        setupRightSideMaskLayout()
        setupBubbleLayout()
    }

    private func setupTitleViewsLayout() {
        guard titleLabels.count == titleViews.count else {
            return
        }
        
        for (index, titleView) in titleViews.enumerated() {
            let frame = titleViewFrame(at: index)
            titleView.frame = frame
            titleLabels[index].frame = CGRect(origin: .zero, size: frame.size)
        }

        let targetTitleView = titleViews[currentIndex]
        let targetLabel = titleLabels[currentIndex]

        if style.isTitleViewScrollEnabled {
            adjustContentSize()
            adjustTitleViewPosition(at: currentIndex)
        }

        if style.isTitleScaleEnabled {
            UIView.animate(withDuration: 0.1, animations: {
                let scaleFactor = self.style.titleMaximumScaleFactor
                targetLabel.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                if self.style.isShowCoverView {
                    self.coverView.transform = CGAffineTransform(scaleX: scaleFactor, y: 1.0)
                }
            }, completion: { (_) in
                if self.style.isTitleScaleEnabled {
                    targetLabel.font = UIFont.boldSystemFont(ofSize: self.style.titleFont.pointSize)
                }
                if self.style.isShowBottomLine {
                    self.bottomLine.frame.size.width = self.style.bottomLineWidth > 0.0 ? self.style.bottomLineWidth : targetTitleView.frame.width
                    self.bottomLine.center.x = targetTitleView.center.x
                }
            })
        } else {
            if style.isSelectedTitleBold {
                targetLabel.font = UIFont.boldSystemFont(ofSize: style.titleFont.pointSize)
            }
        }
    }

    private func setupCoverViewLayout() {
        guard style.isShowCoverView else {
            return
        }
        guard currentIndex < titleLabels.count else {
            return
        }

        let titleView = titleViews[currentIndex]
        var width = titleView.frame.width
        let height = style.coverViewHeight
        if style.isTitleViewScrollEnabled {
            width += 2 * style.coverInset
        }
        coverView.frame.size = CGSize(width: width, height: height)
        coverView.center = titleView.center
    }

    private func setupBottomLineLayout() {
        guard style.isShowBottomLine else {
            return
        }
        guard currentIndex < titleViews.count else {
            return
        }

        let titleView = titleViews[currentIndex]
        bottomLine.frame.size.width = style.bottomLineWidth > 0.0 ? style.bottomLineWidth : titleView.frame.width
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.center.x = titleView.center.x
        bottomLine.frame.origin.y = frame.height - bottomLine.frame.height
    }

    private func setupRightSideMaskLayout() {
        guard style.isShowRightSideMask else {
            return
        }
        guard style.rightSideMaskWidth > 0.0 else {
            return
        }

        let x = frame.width - style.rightSideMaskWidth
        rightSideMask.frame = CGRect(x: x, y: 0.0, width: style.rightSideMaskWidth, height: frame.height)

        if let sublayer = style.rightSideMaskLayer {
            sublayer.frame = rightSideMask.bounds
            rightSideMask.layer.addSublayer(sublayer)
        } else {
            let layer = CAGradientLayer()
            layer.colors = [style.rightSideMaskLayerColor.withAlphaComponent(0.0).cgColor,
                            style.rightSideMaskLayerColor.withAlphaComponent(1.0).cgColor]
            layer.locations = [0.0, 1.0]
            layer.frame = rightSideMask.bounds
            layer.startPoint = CGPoint(x: 0.21, y: 0.5)
            layer.endPoint = CGPoint(x: 0.5, y: 0.5)
            rightSideMask.layer.addSublayer(layer)
        }
    }
    
    private func setupBubbleLayout() {
        guard style.isShowBubble else {
            return
        }
        guard currentIndex < titleLabels.count else {
            return
        }
        adjustBubblePosition(at: currentIndex)
    }
}

extension PageTitleView: PageContentViewDelegate {
    public func contentView(_ contentView: PageContentView, didEndScrollAt index: Int) {
        guard index >= 0, index < titleViews.count, index < titleLabels.count else {
            return
        }

        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[index]
        let sourceTitleView = titleViews[currentIndex]
        let targetTitleView = titleViews[index]

        sourceLabel.textColor = style.titleColor
        targetLabel.textColor = style.titleSelectedColor
        sourceTitleView.backgroundColor = style.titleViewColor
        targetTitleView.backgroundColor = style.titleViewSelectedColor

        currentIndex = index
        adjustTitleViewPosition(at: index)
        updateView(at: index, sourceIndex: currentIndex)
        
        eventHandler?.titleView(self, didEndScrollAt: index)
    }

    public func contentView(_ contentView: PageContentView, scrollingWith sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        guard sourceIndex >= 0, targetIndex >= 0 else {
            return
        }
        guard sourceIndex < titleViews.count, sourceIndex < titleLabels.count,
              targetIndex < titleViews.count, targetIndex < titleLabels.count else {
            return
        }

        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        let sourceTitleView = titleViews[sourceIndex]
        let targetTitleView = titleViews[targetIndex]

        if style.isTitleColorGradient {
            sourceLabel.textColor = UIColor(r: selectRGB.red - progress * deltaRGB.red,
                                            g: selectRGB.green - progress * deltaRGB.green,
                                            b: selectRGB.blue - progress * deltaRGB.blue,
                                            a: selectAlpha - progress * deltaAlpha)
            targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red,
                                            g: normalRGB.green + progress * deltaRGB.green,
                                            b: normalRGB.blue + progress * deltaRGB.blue,
                                            a: normalAlpha + progress * deltaAlpha)
        }

        if style.isTitleScaleEnabled {
            let deltaScale = style.titleMaximumScaleFactor - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.titleMaximumScaleFactor - progress * deltaScale,
                                                      y: style.titleMaximumScaleFactor - progress * deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale,
                                                      y: 1.0 + progress * deltaScale)
        }

        if style.isShowBottomLine {
            if style.bottomLineWidth <= 0.0 {
                let deltaWidth = targetTitleView.frame.width - sourceTitleView.frame.width
                bottomLine.frame.size.width = sourceTitleView.frame.width + progress * deltaWidth
            }
            let deltaCenterX = targetTitleView.center.x - sourceTitleView.center.x
            bottomLine.center.x = sourceTitleView.center.x + progress * deltaCenterX
        }

        if style.isShowCoverView {
            let deltaWidth = targetTitleView.frame.width - sourceTitleView.frame.width
            coverView.frame.size.width = style.isTitleViewScrollEnabled ? (sourceTitleView.frame.width + 2.0 * style.coverInset + progress * deltaWidth) : (sourceTitleView.frame.width + progress * deltaWidth)
            let deltaCenterX = targetTitleView.center.x - sourceTitleView.center.x
            coverView.center.x = sourceTitleView.center.x + progress * deltaCenterX
        }
        
        let isTargetSelected = progress >= (style.isBubbleScrollable ? 0.5 : 0.998)

        if style.isSelectedTitleBold, isTargetSelected {
            sourceLabel.font = style.titleFont
            targetLabel.font = UIFont.boldSystemFont(ofSize: style.titleFont.pointSize)
        }

        if style.isShowBubble {
            if style.isBubbleScrollable {
                if progress >= 0.5 {
                    adjustBubblePosition(at: targetIndex)
                    bubble.alpha = (progress-0.5)*2
                } else {
                    adjustBubblePosition(at: sourceIndex)
                    bubble.alpha = 1-(progress)*2
                }
            } else {
                if isTargetSelected {
                    adjustBubblePosition(at: targetIndex)
                } else {
                    bubble.isHidden = true
                }
            }
        }
    }
}

extension PageTitleView {
    func selectTitle(at index: Int) {
        guard index >= 0, index < titleViews.count, index < titleLabels.count else {
            return
        }

        clickHandler?(self, index)

        if index == currentIndex {
            eventHandler?.titleView(self, didSelectTitleAt: index, isSame: true)
            return
        } else {
            eventHandler?.titleView(self, didSelectTitleAt: index, isSame: false)
        }

        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[index]
        let sourceTitleView = titleViews[currentIndex]
        let targetTitleView = titleViews[index]

        sourceLabel.textColor = style.titleColor
        targetLabel.textColor = style.titleSelectedColor

        eventHandler?.titleView(self, scrollFrom: currentIndex, to: index)
        
        currentIndex = index
        delegate?.titleView(self, didSelectAt: currentIndex)

        adjustTitleViewPosition(at: index)

        if style.isTitleScaleEnabled {
            let scaleFactor = self.style.titleMaximumScaleFactor
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            }) { (finish) in
                if self.style.isSelectedTitleBold {
                    sourceLabel.font = self.style.titleFont
                    targetLabel.font = UIFont.boldSystemFont(ofSize: self.style.titleFont.pointSize)
                }
            }
        } else {
            if style.isSelectedTitleBold {
                sourceLabel.font = style.titleFont
                targetLabel.font = UIFont.boldSystemFont(ofSize: style.titleFont.pointSize)
            }
        }

        if style.isShowBottomLine {
            let width = style.bottomLineWidth > 0.0 ? style.bottomLineWidth : targetTitleView.frame.width
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.size.width = width
                self.bottomLine.center.x = targetTitleView.center.x
            })
        }

        if style.isShowCoverView {
            let width = style.isTitleViewScrollEnabled ? (targetTitleView.frame.width + 2.0 * style.coverInset) : targetTitleView.frame.width
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.size.width = width
                self.coverView.center.x = targetTitleView.center.x
            })
        }
        
        if style.isShowBubble {
            adjustBubblePosition(at: index)
        }

        sourceTitleView.backgroundColor = style.titleViewColor
        targetTitleView.backgroundColor = style.titleViewSelectedColor
    }

    private func adjustContentSize() {
        if let lastTitleView = titleViews.last {
            scrollView.contentSize.width = lastTitleView.frame.maxX + style.titleViewInsets.right
        }
    }
    
    private func adjustTitleViewPosition(at index: Int) {
        guard style.isTitleViewScrollEnabled else {
            return
        }
        guard index >= 0, index < titleViews.count else {
            return
        }
        guard scrollView.contentSize.width > scrollView.frame.width else {
            return
        }

        let targetTitleView = titleViews[index]

        var offsetX = targetTitleView.center.x - 0.5 * frame.width
        if offsetX < 0.0 {
            offsetX = 0.0
        }
        if offsetX > scrollView.contentSize.width - scrollView.frame.width {
            offsetX = scrollView.contentSize.width - scrollView.frame.width
        }

        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    private func adjustBubblePosition(at index: Int, progress: CGFloat = 1) {
        guard style.isShowBubble else {
            return
        }
        guard index >= 0, index < titleViews.count, index < titleLabels.count else {
            return
        }

        let targetTitleView = titleViews[index]
        let targetLabel = titleLabels[index]
        let fontSize = targetLabel.font.pointSize * (style.isTitleScaleEnabled ? style.titleMaximumScaleFactor : 1.0)
        let y = 0.5 * (scrollView.frame.height - fontSize - bubble.frame.height) + 2.0
        let x = targetTitleView.frame.maxX
        bubble.frame.origin = CGPoint(x: x, y: y)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.bubble.isHidden = false
        }
    }
    
    private func adjustBadgePosition(at index: Int) {
        guard index >= 0, index < titleViews.count else {
            return
        }
        
        let titleView = titleViews[index]
        let subview = titleView.subviews.filter { $0.isKind(of: PageBadgeView.self) }.first
        guard let badgeView = subview as? PageBadgeView else {
            return
        }
        
        let insets = style.badgeInsets
        let titleSize = self.titleSize(at: index)
        let x = 0.5 * (titleView.frame.width + titleSize.width) + insets.left
        let y = insets.top
        let size = badgeView.sizeThatFits(titleSize)
        badgeView.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
    }
    
    private func updateView(at targetIndex: Int, sourceIndex: Int) {
        guard sourceIndex >= 0, targetIndex >= 0 else {
            return
        }
        guard sourceIndex < titleViews.count, sourceIndex < titleLabels.count,
              targetIndex < titleViews.count, targetIndex < titleLabels.count else {
            return
        }

        let targetTitleView = titleViews[targetIndex]
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[sourceIndex]
        
        UIView.animate(withDuration: 0.05) {
            targetLabel.textColor = self.style.titleSelectedColor

            if self.style.isTitleScaleEnabled {
                let scaleFactor = self.style.titleMaximumScaleFactor
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            }
            
            if self.style.isSelectedTitleBold {
                sourceLabel.font = self.style.titleFont
                targetLabel.font = UIFont.boldSystemFont(ofSize: self.style.titleFont.pointSize)
            }

            if self.style.isShowBottomLine {
                if self.style.bottomLineWidth <= 0.0 {
                    self.bottomLine.frame.size.width = targetTitleView.frame.width
                }
                self.bottomLine.center.x = targetTitleView.center.x
            }

            if self.style.isShowCoverView {
                self.coverView.frame.size.width = self.style.isTitleViewScrollEnabled ? (targetTitleView.frame.width + 2.0 * self.style.coverInset) : targetTitleView.frame.width
                self.coverView.center.x = targetTitleView.center.x
            }
            
            if self.style.isShowBubble {
                self.adjustBubblePosition(at: targetIndex)
            }
        }
    }
}

extension PageTitleView {
    @objc private func tapTitleLabel(_ tapGestureRecognizer: UITapGestureRecognizer) {
        guard isScrollEnabled else {
            return
        }
        guard let index = tapGestureRecognizer.view?.tag else {
            return
        }
        selectTitle(at: index)
    }
}
