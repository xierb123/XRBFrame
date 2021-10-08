//
//  HomeCustomNavigationBar.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/16.
//
//  首页自定义导航条

import UIKit

class HomeCustomNavigationBar: UIView {
    
    //MARK: - 回调方法
    var scanHandle: (() -> Void)? = nil
    var messageHandle: (() -> Void)? = nil
    var editingBeginHandle: ((String?) -> Void)? = nil
    
    //MARK: - 全局变量
    private var scanButton: UIButton!
   
    
    //MARK: - 懒加载
    /// 搜索输入框组件
    private lazy var searchTextField: HomeSearchTextField = {
        var style = SearchTextFieldStyle()
        let searchTextField = HomeSearchTextField(style: style)
        searchTextField.editingBeginHandle = { [weak self] searchKey in
            self?.editingBeginHandle?(searchKey)
        }
        return searchTextField
    }()
    /// 消息组件
    private lazy var messageView: MessageView = {
        let messageView = MessageView()
        messageView.actionHandle = { [weak self] in
            self?.messageHandle?()
        }
        return messageView
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
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        setupScanButton()
        setupMessageView()
        setupSearchTextField()
    }
    
    private func setupScanButton() {
        scanButton = UIButton()
        scanButton.setImage(UIImage(named: "ic_navigation_scan"), for: UIControl.State.normal)
        scanButton.addTarget(self, action: #selector(scanBtnAction), for: UIControl.Event.touchUpInside)
        self.addSubview(scanButton)
        scanButton.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(Constant.margin)
            make.bottom.equalTo(-Constant.margin)
            make.width.height.equalTo(35)
        }
    }
    
    private func setupMessageView() {
        self.addSubview(messageView)
        messageView.snp.makeConstraints { make in
            make.right.bottom.equalTo(-Constant.margin)
            make.width.height.equalTo(35)
        }
    }
    
    private func setupSearchTextField() {
        self.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(scanButton.snp.right).offset(10)
            make.right.equalTo(messageView.snp.left).offset(-10)
            make.bottom.equalTo(scanButton)
            make.height.equalTo(35)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension HomeCustomNavigationBar {
    
    func setSearchKey(_ array: [String]?) {
        if let array = array {
            self.searchTextField.setSearchKeys(array)
        }
    }
    
    func setMessageNum(_ num: String) {
        func updateMessageNum(_ view: MessageUpdateProtocol) {
            view.messageUpdate(num)
        }
        updateMessageNum(messageView)
    }
    
    @objc private func scanBtnAction() {
        scanHandle?()
    }
}

