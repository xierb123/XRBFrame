//
//  AlertView.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class AlertView: UIView {
    private var type: CustomAlertType?
    private var actions: [CustomAlertAction] = []
    private var alertWidth: CGFloat = 270.0
    
    private var backgroundView: UIView!
    private var containerView: UIView!
    private var contentView: UIView!
    private lazy var actionView: UIView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#636366")
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
        
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(hexString: "#F5F5F5")
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.keyboardType = .default
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = false
        textField.textAlignment = .center
        textField.textColor = UIColor(hexString: "#1A1A1A")
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.delegate = self
        textField.setCornerRadius(20.0)
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        addObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setup() {
        backgroundColor = UIColor.clear
        alpha = 0.0
        
        backgroundView = UIView()
        backgroundView.backgroundColor = Color.mask
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.setCornerRadius(8.0)
        addSubview(containerView)

        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(alertWidth)
        }

        contentView = UIView()
        containerView.addSubview(contentView)
                
        contentView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension AlertView {
    func show(title: String? = nil,
              message: String? = nil,
              actions: [CustomAlertAction]) {
                
        self.type = nil
        self.actions = actions
        addDefaultView(title: title, message: message)
        show()
    }
    
    func show(type: CustomAlertType,
              id: String? = nil,
              actions: [CustomAlertAction]) {
                
        self.type = type
        self.actions = actions
        
        switch type {
        case .pullFlow:
            addPullFlowView()
        case .liveId:
            addLiveIDView(id: id)
        }

        show()
    }
}

extension AlertView {
    /// 默认视图
    private func addDefaultView(title: String?, message: String?) {
        let isTitleEmpty = title?.isEmpty ?? true
        let isMessageEmpty = message?.isEmpty ?? true
        let isActionsEmpty = actions.isEmpty

        if !isTitleEmpty {
            titleLabel.text = title
            contentView.addSubview(titleLabel)
            setTitleLabelLayout(isMessageEmpty: isMessageEmpty)
        }
                
        if !isMessageEmpty {
            messageLabel.text = message
            contentView.addSubview(messageLabel)
            setMessageLabelLayout(isTitleEmpty: isTitleEmpty)
        }
              
        contentView.snp.remakeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview()
            if isActionsEmpty {
                make.bottom.equalTo(-12)
            }
        }

        if !isActionsEmpty {
            addActionBtns(actions: actions)
        }
    }
}

extension AlertView {
    /// 拉流地址视图
    private func addPullFlowView() {
        titleLabel.text = "拉流地址"
        contentView.addSubview(titleLabel)
        setTitleLabelLayout()

        setTextField(placeholder: "请输入拉流地址")
        contentView.addSubview(textField)

        textField.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.right.equalTo(-28)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.bottom.equalTo(-12)
        }

        contentView.snp.remakeConstraints { (make) in
            make.left.top.width.equalToSuperview()
            if actions.isEmpty {
                make.bottom.equalTo(-12)
            }
        }

        if !actions.isEmpty {
            addActionBtns(actions: actions)
        }
    }

    /// 直播ID视图
    private func addLiveIDView(id: String?) {
        show(title: id, message: "直播ID，点击长按可复制", actions: actions)
        
        // 添加长按手势
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pasteBoard(_:)))
        titleLabel.addGestureRecognizer(gestureRecognizer)
    }
}
       
extension AlertView {
    private func setTitleLabelLayout(isMessageEmpty: Bool = false) {
        if isMessageEmpty {
            titleLabel.textColor = UIColor(hexString: "#1A1A1A")
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            if isMessageEmpty {
                make.top.equalTo(28)
                make.bottom.equalTo(-12)
            } else {
                make.top.equalTo(24)
            }
        }
    }
    
    private func setMessageLabelLayout(isTitleEmpty: Bool = false) {
        messageLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-12)
            if isTitleEmpty {
                make.top.equalTo(24)
            } else {
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
            }
        }
    }
     
    private func setTextField(placeholder: String) {
        let attributedPlaceholder = NSAttributedString(string: placeholder,
                                                       attributes: [.foregroundColor: UIColor(hexString: "#CCCCCC"),
                                                                    .font: UIFont.systemFont(ofSize: 16.0)])
        textField.attributedPlaceholder = attributedPlaceholder
    }
}

extension AlertView {
    private func addActionBtns(actions: [CustomAlertAction]) {
        containerView.addSubview(actionView)
        actionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let actionBtnWidth: CGFloat = 96.0
        let actionBtnHeight: CGFloat = 40.0

        for (index, action) in actions.enumerated() {
            let actionBtn = initActionBtn(with: action, at: index)
            actionView.addSubview(actionBtn)
            
            if actions.count == 1 {
                actionBtn.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(12)
                    make.width.equalTo(actionBtnWidth)
                    make.height.equalTo(actionBtnHeight)
                    make.bottom.equalTo(-24)
                }
            } else if actions.count == 2 {
                actionBtn.snp.makeConstraints { (make) in
                    if index == 0 {
                        make.right.equalTo(actionView.snp.centerX).offset(-12)
                    } else {
                        make.left.equalTo(actionView.snp.centerX).offset(12)
                    }
                    make.centerX.equalToSuperview()
                    make.top.equalTo(12)
                    make.width.equalTo(actionBtnWidth)
                    make.height.equalTo(actionBtnHeight)
                    if index == actions.count - 1 {
                        make.bottom.equalTo(-24)
                    }
                }
            } else {
                actionBtn.snp.makeConstraints { (make) in
                    if let lastActionBtn = actionView.subviews.safeObject(at: index - 1) {
                        make.top.equalTo(lastActionBtn.snp.bottom).offset(12)
                    } else {
                        make.top.equalTo(12)
                    }
                    make.centerX.equalToSuperview()
                    make.width.equalTo(actionBtnWidth)
                    make.height.equalTo(actionBtnHeight)
                    if index == actions.count - 1 {
                        make.bottom.equalTo(-24)
                    }
                }
            }
        }
    }
    
    private func initActionBtn(with alertAction: CustomAlertAction, at index: Int) -> UIButton {
        let titleColor = alertAction.type == .default ? UIColor.white : UIColor(hexString: "#1A1A1A")
        let backgroundColor = alertAction.type == .default ? Color.theme : UIColor(hexString: "#F0F0F0")

        let btn = UIButton()
        btn.tag = index
        btn.backgroundColor = backgroundColor
        btn.setTitle(alertAction.title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        btn.setCornerRadius(20.0)
        btn.addTarget(self, action: #selector(actionBtnClicked(_:)), for: .touchUpInside)
        return btn
    }
}

extension AlertView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension AlertView {
    private func show() {
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 1.0
        })
    }

    @objc private func hide() {
        resignFirstResponder()
        UIView.animate(withDuration: 0.15) {
            self.alpha = 0.0
        } completion: { finished in
            self.removeFromSuperview()
        }
    }
        
    @objc private func pasteBoard(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            UIPasteboard.general.string = messageLabel.text
            Toast.show("复制成功")
        }
    }
    
    @objc private func actionBtnClicked(_ sender: UIButton) {
        guard let action = actions.safeObject(at: sender.tag) else {
            return
        }
        
        switch type {
        case .pullFlow:
            let text = textField.text ?? ""
            if action.type == .default {
                let schemes = ["rtmp", "rtsp", "srt"]
                if !text.isEmpty, let scheme = URL(string: text)?.scheme, schemes.contains(scheme) {
                    hide()
                    action.handler??()
                    action.outputHandler??(text)
                } else {
                    textField.resignFirstResponder()
                    Toast.show("请输入正确的rtmp/rtsp/srt协议拉流地址！")
                }
            } else {
                hide()
                action.handler??()
                action.outputHandler??(textField.text)
            }
        case .liveId:
            hide()
            UIPasteboard.general.string = messageLabel.text
            action.handler??()
            action.outputHandler??(messageLabel.text)
        default:
            hide()
            action.handler??()
            action.outputHandler??(nil)
        }
    }
}

extension AlertView {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.keyboardFrame,
              let duration = notification.keyboardAnimationDuration else {
            return
        }

        let keyBoardY = keyboardFrame.minY
        let targetSpacing: CGFloat = 6.0
        var targetCenterY = (keyBoardY - containerView.height / 2.0) - targetSpacing
        targetCenterY = min(height / 2.0, targetCenterY)
        targetCenterY = max(containerView.height / 2.0, targetCenterY)
        
        UIView.animate(withDuration: duration) {
            self.containerView.centerY = targetCenterY
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.keyboardAnimationDuration else {
            return
        }

        UIView.animate(withDuration: duration) {
            self.containerView.centerY = self.height / 2.0
        }
    }
}
