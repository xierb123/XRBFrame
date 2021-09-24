//
//  LoadingView.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import SnapKit

enum LoadingViewStyle {
    case `default`
    case clear
}

class LoadingView: UIView {
    private var imageView: UIImageView!
    private var titleLabel: UILabel!

    private var timer: Timer?
    private var timerProgress: Double = 0.0
    private var isSuperViewScrollEnabled: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        contentView.setCornerRadius(12.0)
        addSubview(contentView)

        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(120)
        }

        imageView = UIImageView()
        imageView.image = UIImage(named: "ic_loading")
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(32)
            make.width.height.equalTo(36)
        }

        titleLabel = UILabel()
        titleLabel.text = "加载中..."
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(12)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(in view: UIView?,
              style: LoadingViewStyle = .default,
              layoutClosure: ((LoadingView) -> Void)? = nil) {

        DispatchQueue.main.safeAsync { [weak self] in
            guard let self = self else { return }
            guard let superView = view ?? UIApplication.shared.keyWindow else {
                return
            }

            if let view = self.superview, view != superView {
                self.removeFromSuperview()
            }

            self.isSuperViewScrollEnabled = false
            if let scrollView = superView as? UIScrollView, scrollView.isScrollEnabled {
                self.isSuperViewScrollEnabled = true
                scrollView.isScrollEnabled = false
            }

            self.backgroundColor = style == .default ? Color.background : UIColor.clear
            superView.addSubview(self)
            superView.bringSubviewToFront(self)

            if let closure = layoutClosure {
                closure(self)
                self.layoutIfNeeded()
            } else {
                self.snp.makeConstraints({ (make) in
                    make.left.top.equalToSuperview()
                    make.width.height.equalToSuperview()
                })
            }

            self.startAnimating()
        }
    }

    func dismiss() {
        DispatchQueue.main.safeAsync {
            guard let superView = self.superview else {
                return
            }

            if self.isSuperViewScrollEnabled, let scrollView = superView as? UIScrollView {
                scrollView.isScrollEnabled = true
                self.isSuperViewScrollEnabled = false
            }

            self.stopAnimating()
            self.removeFromSuperview()
        }
    }
}

extension LoadingView {
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
