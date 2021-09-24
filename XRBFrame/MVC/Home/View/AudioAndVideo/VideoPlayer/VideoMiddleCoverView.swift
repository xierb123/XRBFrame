//
//  VideoMiddleCoverView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/2.
//
//  播放器控制工具条显隐视图组件

import UIKit

class VideoMiddleCoverView: UIView {
    
    //MARK: - 回调方法
    var coverHandle: (() -> Void)? = nil
    
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
        self.backgroundColor = UIColor(hexString: "#00FF00", alpha: 0.3)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension VideoMiddleCoverView {
    /// 控制显隐
    @objc private func tapAction() {
        coverHandle?()
    }
}

