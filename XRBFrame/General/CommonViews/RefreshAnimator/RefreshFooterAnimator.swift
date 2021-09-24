//
//  RefreshFooterAnimator.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import ESPullToRefresh

class RefreshFooterAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    var view: UIView { return self }
    var insets: UIEdgeInsets = .zero
    var trigger: CGFloat = 48.0
    var executeIncremental: CGFloat = 64.0
    var state: ESRefreshViewState = .pullToRefresh
        
    /// 是否展示'没有更多了'
    var isShowNoMore: Bool = false {
        didSet {
            titleLabel.text = isShowNoMore ? noMoreDataDescription : ""
        }
    }
    
    private var timer: Timer?
    private var timerProgress: Double = 0.0

    private let loadingMoreDescription: String = "上拉加载更多"
    private let loadingDescription: String     = "正在加载更多..."
    private let noMoreDataDescription: String  = "已经到底了：）"
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(hexString: "#646466")
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_footer_loading")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.text = loadingMoreDescription
        addSubview(titleLabel)
        addSubview(imageView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(16)
            make.top.equalTo(16)
            make.height.equalTo(16)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-8)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(16)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshAnimationBegin(view: ESRefreshComponent) {
        startAnimating()
        imageView.isHidden = false
    }
    
    func refreshAnimationEnd(view: ESRefreshComponent) {
        stopAnimating()
        imageView.isHidden = true
    }
    
    func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // do nothing
    }
    
    func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing:
            titleLabel.text = loadingDescription
            titleLabel.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview().offset(16.0)
            }
        case .noMoreData:
            imageView.isHidden = true
            titleLabel.text = isShowNoMore ? noMoreDataDescription : ""
            titleLabel.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview()
            }
        default:
            titleLabel.text = loadingMoreDescription
            titleLabel.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview()
            }
        }
    }
}

extension RefreshFooterAnimator {
    private func startAnimating() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    private func stopAnimating() {
        if timer != nil {
            timerProgress = 0.0
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func timerAction() {
        timerProgress += 0.03
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * CGFloat(timerProgress))
    }
}
