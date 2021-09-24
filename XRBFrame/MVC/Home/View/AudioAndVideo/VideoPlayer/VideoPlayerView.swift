//
//  VideoPlayerView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/2.
//
//  视频播放器视图组件

import UIKit
import ZFPlayer

/// 视频播放器样式
public struct VideoPlayerStyle {
    /// 是否允许视频自动全屏
    public var allowOrentitaionRotation: Bool = false
    /// 是否允许因为事件暂停播放
    public var isPauseByEvent: Bool = false
    
}

class VideoPlayerView: UIView {
    
    //MARK: - 回调方法
    /// 视频播放器播放状态改变的回调
    var playerPlayStateChanged: ((ZFPlayerMediaPlayback, ZFPlayerPlaybackState) -> Void)? = nil
    /// 视频播放器播放完成的回调
    var playerDidToEnd: ((ZFPlayerMediaPlayback) -> Void)? = nil
    /// 视频播放器播放失败的回调
    var playerPlayFailed: ((ZFPlayerMediaPlayback, Any) -> Void)? = nil
    
    /// 返回上一页的回调
    var backHandle: ((Bool) -> Void)? = nil
    /// 全屏按钮的回调
    var fullScreenHandle: (() -> Void)? = nil
    
    
    //MARK: - 全局变量
    private var style: VideoPlayerStyle!
    /// 是否全屏状态
    private var isFullScreen: Bool = false
    /// 是否展示工具条
    private var isShowToolsView: Bool = true
    
    private lazy var videoPlayerManager: VideoPlayerManager = {
        let videoPlayerManager = VideoPlayerManager.getSharedInstance()
        videoPlayerManager.addNotification()
        videoPlayerManager.stopPlayHandle = { [weak self] in
            guard let self = self else {return}
            self.playerManager.shouldAutoPlay = false
            self.player.isPauseByEvent = false
            self.playerManager.pause()
        }
        
        videoPlayerManager.setPlayHandle = { [weak self] in
            guard let self = self else {return}
            if let url = URL(string: URLString.video) {
                self.player.assetURL = url
            }
            self.playerManager.play()
        }
        
        videoPlayerManager.showWWAnDialogHandle = { [weak self] in
            guard let self = self else {return}
            self.playerManager.shouldAutoPlay = false
            self.player.isPauseByEvent = false
            self.playerManager.pause()
            self.showWWANDialog()
        }
        
        return videoPlayerManager
    }()
    
    //MARK: - 懒加载
    /// 播放器管理者
    private lazy var playerManager: ZFPlayerMediaPlayback = {
        let playerManager = videoPlayerManager.getVideoPlayerManager(with: .video)
        playerManager.shouldAutoPlay = true
        return playerManager
    }()
    
    /// 承载播放器的组件
    private lazy var videoView: UIView = {
        let videoView = UIView()
        videoView.backgroundColor = self.backgroundColor
        return videoView
    }()
    
    /// 播放器
    private lazy var player: ZFPlayerController = {
        let player = ZFPlayerController(playerManager: playerManager, containerView: videoView)
        player.allowOrentitaionRotation = style.allowOrentitaionRotation
        player.isPauseByEvent = style.isPauseByEvent
        player.controlView = controlView
        /// 播放状态改变
        player.playerPlayStateChanged = { [weak self] (asset, state) in
            guard let self = self else { return }
            self.playerPlayStateChanged?(asset, state)
        }
        /// 播放完成
        player.playerDidToEnd = { [weak self] (asset) in
            guard let self = self else { return }
            self.playerDidToEnd?(asset)
            
        }
        /// 播放失败
        player.playerPlayFailed = { [weak self] (asset, error) in
            guard let self = self else { return }
            self.playerPlayFailed?(asset, error)
        }
        
        /// 播放时间变化
        player.playerPlayTimeChanged = { [weak self] (asset, currentTime, totalTime) in
            guard let self = self else {return}
            
            self.updateTime(with: ZFUtilities.convertTimeSecond(Int(currentTime)),
                            totalTime: ZFUtilities.convertTimeSecond(Int(totalTime)),
                            progress: player.progress)
        }
        
        return player
    }()
    
    /// 视频播放器控制组件
    private lazy var  controlView: ZFPlayerControlView = {
        let controlView = ZFPlayerControlView()
        controlView.fastViewAnimated = true                              // 快进视图是否显示动画
        controlView.autoHiddenTimeInterval = 5                           // 控制层自动隐藏的时间
        controlView.autoFadeTimeInterval = 0.5                           // 控制层显示、隐藏动画的时长
        controlView.prepareShowLoading = true                            // 准备播放的时候时候是否显示loading
        controlView.prepareShowControlView = true                        // 准备播放时候是否显示控制层
        controlView.portraitControlView.titleLabel.isHidden = true       // 非全屏状态下隐藏标题
        controlView.bgImgView.isHidden = true
        controlView.portraitControlView.removeFromSuperview()            // 播放器竖屏控制器隐藏
        controlView.landScapeControlView.removeFromSuperview()           // 播放器横屏控制器隐藏
        
        return controlView
    }()
    
    /// 顶部工具条
    private lazy var topToolsView: VideoTopToolsView = {
        let toolsView = VideoTopToolsView()
        toolsView.backHandle = { [weak self] in
            guard let self = self else {return}
            printLog("返回")
            self.backHandle?(self.isFullScreen)
        }
        toolsView.fullScreenHandle = { [weak self] in
            printLog("全屏")
            self?.fullScreenHandle?()
        }
        
        return toolsView
    }()
    
    /// 底部工具条
    private lazy var bottomToolsView: VideoBottomToolsView = {
        let toolsView = VideoBottomToolsView()
        toolsView.playHandle = { [weak self] in
            guard let self = self else {return}
            if self.playerManager.isPlaying {
                self.playerManager.pause()
            } else {
                self.playerManager.play()
            }
            self.bottomToolsView.setPlayBtnIcon(isPlay: self.playerManager.isPlaying)
        }
        toolsView.progressChangedHandle = { [weak self] value in
            guard let self = self else {return}
            if value == 1 { // 播放完成
                self.playerManager.pause()
                //self.replayButton.isHidden = false
                return
            }
            self.playerManager.seek(toTime: self.playerManager.totalTime * Double(value)) { [weak self] finished in
                guard let self = self else {return}
                self.playerManager.play()
            }
        }
        return toolsView
    }()
    
    /// 播放器控制工具条显隐视图组件
    private lazy var middleCoverView: VideoMiddleCoverView = {
        let coverView = VideoMiddleCoverView()
        coverView.coverHandle = { [weak self] in
            guard let self = self else {return}
            if self.isShowToolsView { // 隐藏工具条
                self.hideToolsView()
            } else { // 展示工具条
                self.showToolView()
            }
        }
        
        return coverView
    }()
    
    //MARK: - init/deinit
    init(style: VideoPlayerStyle, frame: CGRect) {
        self.style = style
        super.init(frame: frame)
        self.clipsToBounds = true
        
        setupView()
        networkCheck()
        //videoPlayerManager.setPlayUrl(player: player, url: URL(string: URLString.video)!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupVideoView()
        addTopToolsView()
        addBottomToolsView()
        addMiddleCoverView()
        
        videoPlayerManager.hideToolsView() { [weak self] in
            self?.hideToolsView()
        }
    }
    
    /// 设置播放器承载组件
    private func setupVideoView() {
        self.addSubview(videoView)
        videoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 设置顶部工具条
    private func addTopToolsView() {
        self.addSubview(topToolsView)
        setupTopToolsView()
    }
    private func setupTopToolsView() {
        let height: CGFloat = isFullScreen ? 80 : 60
        topToolsView.frame = CGRect(x: 0, y: 0, width: Constant.screenWidth, height: height)
    }
    
    /// 设置底部工具条
    private func addBottomToolsView() {
        self.addSubview(bottomToolsView)
        setupBottomToolsView()
    }
    private func setupBottomToolsView() {
        let height: CGFloat = isFullScreen ? 80 : 60
        let y = self.isFullScreen ? (Constant.screenHeight - height) : (self.height - height)
        
        bottomToolsView.frame = CGRect(x: 0, y: y, width: Constant.screenWidth, height: height)
    }
    
    /// 设置播放器控制工具条显隐视图组件
    private func addMiddleCoverView() {
        self.addSubview(middleCoverView)
        setupMiddleCoverView()
    }
    private func setupMiddleCoverView() {
        let height = (self.isFullScreen ? Constant.screenHeight : self.height)-topToolsView.height-bottomToolsView.height
        middleCoverView.frame = CGRect(x: 0, y: topToolsView.height, width: Constant.screenWidth, height: height)
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension VideoPlayerView {
    
    /// 设置视频的全屏状态
    func setFullScreen(with isFullScreen: Bool, animation: Bool = true, finishedHandle: (() -> ())? = nil) {
        removeToolsView()
        
        self.isFullScreen = isFullScreen
        self.topToolsView.setFullScreen(with: isFullScreen)
        self.bottomToolsView.setFullScreen(with: isFullScreen)
        
        self.player.enterFullScreen(isFullScreen, animated: animation) { [weak self] in
            guard let self = self else {return}
            if isFullScreen {
                self.addToolsViewForFullScreen()
            } else {
                self.addToolsViewForNormal()
            }
            finishedHandle?()
        }
    }
    /// 移除工具条
    private func removeToolsView() {
        topToolsView.removeFromSuperview()
        bottomToolsView.removeFromSuperview()
        middleCoverView.removeFromSuperview()
    }
    
    /// 添加正常状态下的工具条
    private func addToolsViewForNormal() {
        self.addSubview(topToolsView)
        setupTopToolsView()
        
        self.addSubview(bottomToolsView)
        setupBottomToolsView()
        
        self.addSubview(middleCoverView)
        setupMiddleCoverView()
    }
    
    /// 添加全屏状态下的工具条
    private func addToolsViewForFullScreen() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(topToolsView)
            setupTopToolsView()
            
            window.addSubview(bottomToolsView)
            setupBottomToolsView()
            
            window.addSubview(middleCoverView)
            setupMiddleCoverView()
        }
    }
    
    /// 更新当前播放时间 和 总时间
    func updateTime(with currentTime: String, totalTime: String, progress: Float) {
        bottomToolsView.updateTime(with: currentTime, totalTime: totalTime, progress: progress)
    }
    
    /// 设置自动播放状态
    func setAutoPlay(isAuto: Bool) {
        self.player.isViewControllerDisappear = !isAuto
        playerManager.shouldAutoPlay = isAuto
    }
    
    /// 清空单例
    func releaseObject() {
        videoPlayerManager.removeNotification()
        VideoPlayerManager.releaseObject()
    }
    
    /// 网络状态判断
    private func networkCheck() {
        videoPlayerManager.setPlayUrl(player: self.player, url: URL(string: URLString.video)!)
        return
        
        let status = NetworkReachabilityMonitor.reachabilityStatus
        switch status {
        case .reachable(.cellular):
            showWWANDialog()
        case .notReachable:
            showWWANDialog()
        default:
            videoPlayerManager.setPlayUrl(player: self.player, url: URL(string: URLString.video)!)
        }
    }
    
    /// 移动网络弹窗提醒
    private func showWWANDialog() {
        Alert.show(title: Message.usingWWAN, actions: [
            CustomAlertAction(title: "停止播放", type: .cancel, handler: {
                if self.isFullScreen {
                    self.player.enterFullScreen(false, animated: true) {
                        self.backHandle?(false)
                    }
                } else {
                    self.backHandle?(false)
                }
            }),
            CustomAlertAction(title: "继续播放", type: .default, handler: {
                if self.videoPlayerManager.hasPlayed {
                    self.playerManager.play()
                } else {
                    self.videoPlayerManager.setPlayUrl(player: self.player, url: URL(string: URLString.video)!)
                }
            })
        ])
        
//        let alertVC = UIAlertController(title: Message.usingWWAN, message: nil, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "停止播放", style: .default) { action in
//            if self.isFullScreen {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.player.enterFullScreen(false, animated: true) {
//                        self.backHandle?(false)
//                    }
//                }
//            } else {
//                self.backHandle?(false)
//            }
//        }
//        let confirmAction = UIAlertAction(title: "继续播放", style: .default) { action in
//            if self.videoPlayerManager.hasPlayed {
//                self.playerManager.play()
//            } else {
//                self.videoPlayerManager.setPlayUrl(player: self.player, url: URL(string: URLString.video)!)
//            }
//        }
//        alertVC.addAction(cancelAction)
//        alertVC.addAction(confirmAction)
//        if let window = UIApplication.shared.keyWindow?.rootViewController {
//            window.presentVC(alertVC)
//        }
    }
    
    @objc func abc() {
        if self.isFullScreen {
            self.player.enterFullScreen(false, animated: true) {
                self.backHandle?(false)
            }
        } else {
            self.backHandle?(false)
        }
    }
    
    /// 隐藏工具条
    private func hideToolsView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {return}
            self.topToolsView.bottom = 0
            self.bottomToolsView.top = self.isFullScreen ? Constant.screenHeight : self.height
            
            let height = self.isFullScreen ? Constant.screenHeight : self.height
            self.middleCoverView.frame = CGRect(x: 0, y: 0, width: Constant.screenWidth, height: height)
        } completion: { [weak self] finished in
            guard let self = self else {return}
            if finished {
                self.topToolsView.isHidden = true
                self.bottomToolsView.isHidden = true
                self.videoPlayerManager.endTimer()
                self.isShowToolsView = false
            }
        }
    }
    
    /// 展示工具条
    private func showToolView() {
        self.topToolsView.isHidden = false
        self.bottomToolsView.isHidden = false
        self.isShowToolsView = true
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {return}
            self.topToolsView.top = 0
            self.bottomToolsView.bottom = self.isFullScreen ? Constant.screenHeight : self.height
            
            let height = (self.isFullScreen ? Constant.screenHeight : self.height)-self.topToolsView.height-self.bottomToolsView.height
            self.middleCoverView.frame = CGRect(x: 0, y: self.topToolsView.height, width: Constant.screenWidth, height: height)
        }
        videoPlayerManager.hideToolsView() { [weak self] in
            self?.hideToolsView()
        }
    }
}

