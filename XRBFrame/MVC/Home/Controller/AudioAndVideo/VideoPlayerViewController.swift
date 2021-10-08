//
//  ModuleVideoPlayerViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/2.
//
//  自定义视频播放器页面

import UIKit

class VideoPlayerViewController: BaseViewController {
    
    //MARK: - 全局变量
    var firstClick: Date?
    var secondClick: Date?
    
    //MARK: - 懒加载
    
    /// 视频播放器
    private lazy var playerView: VideoPlayerView = {
        let style = VideoPlayerStyle()
        
        let playerView = VideoPlayerView(style: style,frame: CGRect(x: 0, y: 100, width: Constant.screenWidth, height: 350))
        playerView.playerPlayStateChanged = { (asset, state) in
            printLog("player状态改变 - \(asset)")
            printLog("player状态改变 - \(state)")
        }
        playerView.playerDidToEnd = { (asset) in
            printLog("player播放完成 - \(asset)")
        }
        playerView.playerPlayFailed = { (asset, state) in
            printLog("player播放失败 - \(asset)")
            printLog("player播放失败 - \(state)")
        }
        playerView.backHandle = { [weak self] (isFullScreen) in
            if isFullScreen {
                playerView.setFullScreen(with: false)
            } else {
                self?.clickBackBtn()
            }
        }
        playerView.fullScreenHandle = {
            playerView.setFullScreen(with: true)
        }
        return playerView
    }()
    
    private lazy var repeatButton: UIButton = {
        let button = UIButton()
        button.setTitle("测试重复点击", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(repeatBtnAction), for: UIControl.Event.touchDownRepeat)
        button.largeEdge = 10
        return button
    }()
    
    private lazy var customButton: UIButton = {
        let button = UIButton()
        button.setTitle("测试连续点击", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(customButtonAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.setTitle("测试响应事件", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(testButtonAction), for: UIControl.Event.touchUpInside)
        button.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(testTapGestureAction)))
        return button
    }()
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        playerView.releaseObject()
    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerView.setAutoPlay(isAuto: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.setAutoPlay(isAuto: false)
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupPlayerView()
        setupRepeatButton()
        setupCustomButton()
        setupTestButton()
    }
    
    private func setupPlayerView() {
        self.view.addSubview(playerView)
    }
    
    private func setupRepeatButton() {
        self.view.addSubview(repeatButton)
        repeatButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(playerView.snp.bottom).offset(60)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
    }
    
    private func setupCustomButton() {
        self.view.addSubview(customButton)
        customButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(repeatButton.snp.bottom).offset(60)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
    }
    
    private func setupTestButton() {
        self.view.addSubview(testButton)
        testButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(customButton.snp.bottom).offset(60)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension VideoPlayerViewController {
    
    @objc func repeatBtnAction() {
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        print("当前点击 - \(strNowTime)")
    }
    
    @objc func customButtonAction() {
        if let firstClick = firstClick{
            if Date().secondsSince(firstClick) < 0.3 { // 0.3秒内完成双击视为单次点击
                print("快速单击 - \(Date().secondsSince(firstClick))")
            } else if Date().secondsSince(firstClick) < 0.8 { // 0.3秒至0.5秒内完成双击可生效
                print("双击 - \(Date().secondsSince(firstClick))")
            }
            self.firstClick = nil
            return
        }
        self.firstClick = Date()
    }
    
    @objc func testButtonAction() {
        printLog("按钮点击事件")
    }
    
    @objc func testTapGestureAction() {
        printLog("手势响应事件")
    }
}

//MARK: - 数据请求
extension VideoPlayerViewController {
    
    
}
