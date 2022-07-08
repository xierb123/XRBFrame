//
//  NetworkExceptionView.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import SnapKit

typealias ReloadClosure = (NetworkExceptionStyle) -> Void
public typealias BackClosure = () -> Void

enum NetworkExceptionStyle {
    /// 网络异常
    case exception
    /// 无网络
    case noNetwork
    /// 页面走丢
    case pageDismiss
    /// 用户不存在或已注销
    case disableAccount
    /// 查看用户被禁用
    case userDisabled
    /// 视频已被下架/删除
    case invalidVideo
}

enum NetworkExceptionTheme {
    case light
    case dark
    case clear
}

class NetworkExceptionView: UIView {
    var style: NetworkExceptionStyle = .exception

    private var backBtn: UIButton!
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var reloadBtn: UIButton!

    private var isScrollEnabled: Bool = false
    private var isOriginnalScrollEnabled: Bool = false
    private var reloadClosure: ReloadClosure?
    private var backClosure: BackClosure?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white
        
        backBtn = UIButton()
        backBtn.isHidden = true
        backBtn.setImage(UIImage(named: "ic_navigation_back_black"), for: .normal)
        backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        addSubview(backBtn)
        
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(Constant.statusBarHeight + Constant.navigationBarHeight / 2.0)
            make.width.height.equalTo(24)
        }

        imageView = UIImageView()
        addSubview(imageView)

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hexString: "#999999")
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalTo(snp.centerY)
            make.width.equalToSuperview()
        }

        reloadBtn = UIButton()
        reloadBtn.setTitle("重试", for: .normal)
        reloadBtn.backgroundColor = Color.theme
        reloadBtn.setTitleColor(.white, for: .normal)
        reloadBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        reloadBtn.setCornerRadius(20.0)
        reloadBtn.addTarget(self, action: #selector(clickReloadBtn), for: .touchUpInside)
        addSubview(reloadBtn)
        
        reloadBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.width.equalTo(136)
            make.height.equalTo(40)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in view: UIView?,
              style: NetworkExceptionStyle = .exception,
              theme: NetworkExceptionTheme = .light,
              isShowBack: Bool = false,
              isScrollEnabled: Bool = false,
              layoutClosure: ((NetworkExceptionView) -> Void)? = nil,
              reloadClosure: ReloadClosure? = nil,
              backClosure: BackClosure? = nil) {

        self.style = style
        self.isScrollEnabled = isScrollEnabled
        
        if let closure = reloadClosure {
            self.reloadClosure = closure
        }
        if let backClosure = backClosure {
            self.backClosure = backClosure
        }

        DispatchQueue.main.safeAsync { [weak self] in
            guard let self = self else { return }
            guard let superView = view ?? UIApplication.shared.keyWindow else {
                return
            }

            if let view = self.superview, view != superView {
                self.removeFromSuperview()
            }
            
            self.isOriginnalScrollEnabled = false
            if !self.isScrollEnabled {
                if let scrollView = superView as? UIScrollView, scrollView.isScrollEnabled {
                    self.isOriginnalScrollEnabled = true
                    scrollView.isScrollEnabled = false
                }
            }
            
            switch style {
            case .exception:
                self.imageView.image = UIImage(named: "ic_page_error")
                self.titleLabel.text = "服务器异常，请稍后重试"
            case .noNetwork:
                self.imageView.image = UIImage(named: "ic_page_error")
                self.titleLabel.text = "网络未连接，请检查网络设置"
            case .pageDismiss:
                self.imageView.image = UIImage(named: "ic_page_dismiss")
                self.titleLabel.text = "您访问的页面不见了"
            case .disableAccount:
                self.imageView.image = UIImage(named: "ic_page_disable")
                self.titleLabel.text = "用户不存在或已注销"
                self.reloadBtn.removeFromSuperview()
            case .userDisabled:
                self.imageView.image = UIImage(named: "ic_page_disable")
                self.titleLabel.text = "查看用户被禁用"
                self.reloadBtn.removeFromSuperview()
            case .invalidVideo:
                self.imageView.image = UIImage(named: "ic_page_disable")
                self.titleLabel.text = "视频已被下架/删除，看看其他视频吧"
                self.reloadBtn.removeFromSuperview()
            }
            
            switch theme {
            case .light:
                self.backgroundColor = UIColor.white
                self.backBtn.setImage(UIImage(named: "ic_navigation_back_black"), for: .normal)
            case .dark:
                self.backgroundColor = UIColor(hexString: "#1E2026")
                self.backBtn.setImage(UIImage(named: "ic_navigation_back"), for: .normal)
            case .clear:
                self.backgroundColor = UIColor.clear
            }
            
            self.backBtn.isHidden = !isShowBack
            self.imageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(self.titleLabel.snp.top).offset(-24)
                make.width.equalTo(style == .pageDismiss ? 201 : 139)
                make.height.equalTo(style == .pageDismiss ? 90 : 104)
            }

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
        }
    }

    func dismiss() {
        DispatchQueue.main.safeAsync {
            guard let superView = self.superview else {
                return
            }

            if !self.isScrollEnabled {
                if self.isOriginnalScrollEnabled, let scrollView = superView as? UIScrollView {
                    scrollView.isScrollEnabled = true
                    self.isOriginnalScrollEnabled = false
                }
            }

            self.removeFromSuperview()
        }
    }
}

extension NetworkExceptionView {
    @objc private func clickReloadBtn() {
        reloadClosure?(style)
        if !NetworkReachabilityMonitor.isReachable {
            Toast.show(Message.noNetwork)
        }
    }
    
    @objc private func clickBackBtn() {
        backClosure?()
    }
}
