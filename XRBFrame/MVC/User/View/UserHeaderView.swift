//
//  UserHeaderView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/12.
//

import UIKit

class UserHeaderView: UIView {
    //MARK: - 全局变量
    private var backdroundImageView: UIImageView!
    
    //MARK: - 懒加载
    
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
        backdroundImageView = UIImageView()
        backdroundImageView.backgroundColor = .green
        backdroundImageView.image = UIImage(named: "bg_dengluye")
        backdroundImageView.contentMode = .scaleAspectFill
        backdroundImageView.clipsToBounds = true
        backdroundImageView.frame = CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 300)
        self.addSubview(backdroundImageView)
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension UserHeaderView {
    
}

