//
//  VideoTopToolsView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/2.
//
//  视频播放器顶部工具条视图组件

import UIKit

class VideoTopToolsView: UIView {
    
    //MARK: - 回调方法
    var backHandle: (() -> Void)? = nil
    var fullScreenHandle: (() -> Void)? = nil
    
    //MARK: - 全局变量
    /// 是否全屏状态
    private var isFullScreen: Bool = false {
        didSet {
            if isFullScreen {
                //gradualLayer.frame.size.width = Constant.screenHeight
                sideMargin = Constant.margin * 3
            } else {
                //gradualLayer.frame.size.width = Constant.screenWidth
                sideMargin = Constant.margin
            }
            fullScreenButton.setHidden(isFullScreen)
            
            layoutIfNeeded()
        }
    }
    /// 组件距离边框的间距
    private var sideMargin: CGFloat = Constant.margin
    /// 返回按钮
    private var backButton: UIButton!
    /// 视频标题
    private var titleLabel: UILabel!
    /// 菜单按钮
    private var fullScreenButton: UIButton!
    
    //MARK: - 懒加载
    /// 渐变色layer
    private lazy var gradualLayer: CAGradientLayer = {
        layoutIfNeeded()
        let gradualLayer = Layer.custom(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height), cornerRadius: nil, startColor: UIColor(hexString: "#FF0000", alpha: 0.2), endColor: UIColor(hexString: "#FF0000", alpha: 0.35), startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 0, y: 0))
        return gradualLayer
    }()
    
    //MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupBackButton()
        setupMenuButton()
        setupTitleLabel()
        
    }
    /// 设置渐变色背景
    private func setupBackgroundLayer() {
        gradualLayer.removeFromSuperlayer()
        resetLayerSize()
        self.layer.addSublayer(gradualLayer)
        
        /// 设置渐变层尺寸, 关闭隐式动画效果
        func resetLayerSize() {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradualLayer.frame.size = self.size
            CATransaction.commit()
        }
    }
    
    private func setupBackButton() {
        backButton = UIButton()
        backButton.setImage(UIImage(named: "ic_navigation_back"), for: UIControl.State.normal)
        backButton.addTarget(self, action: #selector(backBtnAction), for: UIControl.Event.touchUpInside)
        backButton.setHidden(false)
        self.addSubview(backButton)
    }
    
    private func setupMenuButton() {
        fullScreenButton = UIButton()
        fullScreenButton.setImage(UIImage(named: "ic_screen_landscape"), for: UIControl.State.normal)
        fullScreenButton.addTarget(self, action: #selector(fullScreenBtnAction), for: UIControl.Event.touchUpInside)
        fullScreenButton.setHidden(false)
        //fullScreenButton.largeEdge = 20.0
        self.addSubview(fullScreenButton)
        
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.text = "标题"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.addSubview(titleLabel)
        
    }
    
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        setupBackgroundLayer()
        
        backButton.snp.remakeConstraints { (make) in
            // 自动布局
            make.left.equalTo(sideMargin)
            make.top.equalTo(sideMargin)
            make.width.height.equalTo(24)
        }
        
        fullScreenButton.snp.remakeConstraints { (make) in
            // 自动布局
            make.right.equalTo(-sideMargin)
            make.centerY.width.height.equalTo(backButton)
        }
        
        titleLabel.snp.remakeConstraints { (make) in
            // 自动布局
            make.left.equalTo(backButton.snp.right).offset(Constant.margin)
            make.right.equalTo(fullScreenButton.snp.left).offset(-Constant.margin)
            make.centerY.height.equalTo(backButton)
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension VideoTopToolsView {
    @objc private func backBtnAction() {
        backHandle?()
    }
    
    @objc private func fullScreenBtnAction() {
        fullScreenHandle?()
    }
    
    /// 设置是否为全屏状态
    func setFullScreen(with isFullScreen: Bool) {
        self.isFullScreen = isFullScreen
    }
}

