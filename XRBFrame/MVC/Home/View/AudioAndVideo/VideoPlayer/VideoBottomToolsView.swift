//
//  VideoBottomToolsView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/2.
//
//  视频播放器底部工具条视图组件

import UIKit

class VideoBottomToolsView: UIView {
    
    
    //MARK: - 回调方法
    
    /// 播放按钮回调
    var playHandle: (() -> Void)? = nil
    /// 进度条拖动回调
    var progressChangedHandle: ((Float) -> Void)? = nil
    
    //MARK: - 全局变量
    /// 是否全屏状态
    private var isFullScreen: Bool = false {
        didSet {
            if isFullScreen {
                sideMargin = Constant.margin * 3
            } else {
                sideMargin = Constant.margin
            }
            
            layoutIfNeeded()
        }
    }
    /// 组件距离边框的间距
    private var sideMargin: CGFloat = Constant.margin
    /// 播放 / 暂停按钮
    private var playButton: UIButton!
    /// 当前时间
    private var currentTimeLabel: UILabel!
    /// 总时间
    private var totalTimeLabel: UILabel!
    /// 进度条
    private var progressSlider: UISlider!
    /// 进度条是否正在拖拽
    private var isProgressDrag: Bool = false
    
    //MARK: - 懒加载
    /// 渐变色layer
    private lazy var gradualLayer: CAGradientLayer = {
        layoutIfNeeded()
        let gradualLayer = Layer.custom(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height), cornerRadius: nil, startColor: UIColor(hexString: "#FF0000", alpha: 0.2), endColor: UIColor(hexString: "#FF0000", alpha: 0.35), startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
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
        setupPlayButton()
        setupPlayTimeLabel()
        setupTotalTimeLabel()
        setupProgressSlider()
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
    
    // 暂停/播放按钮
    private func setupPlayButton() {
        playButton = UIButton()
        playButton.setImage(UIImage(named: "ic_video_pause"), for: UIControl.State.normal)
        playButton.imagePosition(style: .left, spacing: 4.0)
        playButton.addTarget(self, action: #selector(videoPlay), for: UIControl.Event.touchUpInside)
        self.addSubview(playButton)
        
    }
    
    // 当前播放时间
    private func setupPlayTimeLabel() {
        currentTimeLabel = UILabel()
        currentTimeLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.8)
        currentTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.addSubview(currentTimeLabel)
        
    }
    
    // 总时长
    private func setupTotalTimeLabel() {
        totalTimeLabel = UILabel()
        totalTimeLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.8)
        totalTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.addSubview(totalTimeLabel)
    }
    
    // 进度条
    private func setupProgressSlider() {
        progressSlider = UISlider()
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.setThumbImage(UIImage(named: "ic_slider"), for: .normal)
        progressSlider.isContinuous = true
        progressSlider.minimumTrackTintColor = .white
        progressSlider.addTarget(self, action: #selector(progressTouchBegin), for: .touchDown)
        progressSlider.addTarget(self, action: #selector(progressTouchEnd), for: .touchUpInside)
        self.addSubview(progressSlider)
        
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        setupBackgroundLayer()
        
        playButton.snp.remakeConstraints { (make) in
            make.left.equalTo(sideMargin)
            make.bottom.equalTo(-sideMargin)
            make.width.height.equalTo(25.0)
        }
        
        currentTimeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(playButton.snp.right).offset(Constant.margin)
            make.centerY.equalTo(playButton)
            make.height.equalTo(20)
        }
        
        totalTimeLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(-sideMargin)
            make.centerY.height.equalTo(currentTimeLabel)
        }
        
        progressSlider.snp.remakeConstraints { (make) in
            make.left.equalTo(currentTimeLabel.snp.right).offset(Constant.margin)
            make.right.equalTo(totalTimeLabel.snp.left).offset(-Constant.margin)
            make.height.centerY.equalTo(currentTimeLabel)
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension VideoBottomToolsView {
    /// 更新当前播放时间 和 总时间
    func updateTime(with currentTime: String, totalTime: String, progress: Float) {
        currentTimeLabel.text = currentTime
        totalTimeLabel.text = totalTime
        
        if !isProgressDrag {
            progressSlider.setValue(progress, animated: true)
        }
    }
    /// 视频播放
    @objc private func videoPlay() {
        
        playHandle?()
    }
    /// 进度条开始拖动
    @objc private func progressTouchBegin() {
        isProgressDrag = true
    }
    /// 进度条拖动完成
    @objc private func progressTouchEnd() {
        isProgressDrag = false
        progressChangedHandle?(progressSlider.value)
    }
    /// 设置是否为全屏状态
    func setFullScreen(with isFullScreen: Bool) {
        self.isFullScreen = isFullScreen
    }
    
    /// 设置播放按钮图标
    func setPlayBtnIcon(isPlay: Bool) {
        playButton.setImage(UIImage(named: isPlay ? "ic_video_pause" : "ic_video_play"), for: UIControl.State.normal)
    }
}

