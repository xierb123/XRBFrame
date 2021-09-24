//
//  RefreshHeaderAnimator.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import ESPullToRefresh

class RefreshHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    // 下拉偏移距离（例如刘海屏上居于屏幕顶部下拉刷新，可加大该值来展示完整的刷新视图）
    var offset: CGFloat = 0.0

    var insets: UIEdgeInsets = UIEdgeInsets.zero
    var view: UIView { return self }
    var duration: TimeInterval = 0.3
    var trigger: CGFloat {
        set {}
        get {
            return 58.0 + offset
        }
    }
    var executeIncremental: CGFloat {
        set {}
        get {
            return 58.0 + offset
        }
    }
    var state: ESRefreshViewState = .pullToRefresh
    
    private var timer: Timer?
    private var imageIndex: Int = 1
    
    private lazy var animationImages: [UIImage] = {
        var images = [UIImage]()
        for index in 1...39 {
            if let aImage = UIImage(named: "ic_pull_animation_\(index)") {
                images.append(aImage)
            }
        }
        return images
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_pull_animation_1")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-9)
            make.width.height.equalTo(40)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshAnimationBegin(view: ESRefreshComponent) {
        startAnimating()
    }
    
    func refreshAnimationEnd(view: ESRefreshComponent) {
        stopAnimating()
    }
    
    func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
    }
    
    func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .pullToRefresh:
            stopAnimating()
        case .refreshing:
            startAnimating()
        case .releaseToRefresh:
            stopAnimating()
        default:
            break
        }
    }
}

extension RefreshHeaderAnimator {
    private func startAnimating() {
        imageIndex = 1
        imageView.image = UIImage(named: "ic_pull_animation_1")

        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    private func stopAnimating() {
        imageIndex = 1
        imageView.image = UIImage(named: "ic_pull_animation_1")

        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func timerAction() {
        if imageIndex < 39 {
            imageIndex += 1
        } else {
            imageIndex = 1
        }
        imageView.image = animationImages[safe: imageIndex]
    }
}
