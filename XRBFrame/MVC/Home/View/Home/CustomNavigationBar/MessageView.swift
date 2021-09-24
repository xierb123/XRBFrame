//
//  MessageView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/16.
//
//  首页自定义导航条消息组件

import UIKit

protocol MessageUpdateProtocol: class {
    func messageUpdate(_ value: String?)
}

class MessageView: UIView {
    
    //MARK: - 代理协议
    weak var delegate: MessageUpdateProtocol?
    
    //MARK: - 回调方法
    var actionHandle: (() -> Void)? = nil
    
    //MARK: - 全局变量
    private var messageIcon: UIImageView!
    /// 消息数量
    private var numberLabel: UILabel!
    
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupMessageIcon()
        setupNumberLabel()
    }
    
    private func setupMessageIcon() {
        messageIcon = UIImageView()
        messageIcon.image = UIImage(named: "ic_personal_subscription")
        messageIcon.contentMode = .scaleAspectFit
        self.addSubview(messageIcon)
        messageIcon.snp.makeConstraints { (make) in
            // 自动布局
            make.left.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
    }
    
    private func setupNumberLabel() {
        let numberView = UIView()
        numberView.backgroundColor = .red
        numberView.setCornerRadius(7.5,masksToBounds: true)
        self.addSubview(numberView)
        numberView.snp.makeConstraints { (make) in
            // 自动布局
            make.top.equalTo(messageIcon).offset(-10)
            make.left.equalTo(messageIcon).offset(10)
            make.height.equalTo(15)
            make.width.greaterThanOrEqualTo(15)
        }
        
        numberLabel = UILabel()
        numberLabel.textAlignment = .center
        numberLabel.textColor = .white
        numberLabel.font = UIFont.systemFont(ofSize: 8  , weight: .regular)
        numberView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.height.centerY.equalToSuperview()
            make.left.equalTo(3)
            make.right.equalTo(-3)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension MessageView {
    @objc private func tapAction() {
        actionHandle?()
    }
}

//MARK: - 消息更新协议方法
extension MessageView: MessageUpdateProtocol{
    func messageUpdate(_ value: String?) {
        
        guard let value = value else {
            numberLabel.isHidden = true
            return
        }
        numberLabel.isHidden = false
        numberLabel.text = value
    }
}

