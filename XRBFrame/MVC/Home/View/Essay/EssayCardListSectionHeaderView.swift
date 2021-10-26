//
//  EssayCardListSectionHeaderView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/22.
//
//  卡片子列表表头视图组件

import UIKit

class EssayCardListSectionHeaderView: UIView {
    
    //MARK: - 回调方法
    var headerHandle: ((Int) -> Void)? = nil
    
    //MARK: - 全局变量
    private var index: Int!
    private var contentView: UIView!
    private var titleLabel: UILabel!
    
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    /*init(<#parameter#>: <#Object#>) {
     super.init(frame: .zero)
     
     setupView()
     }*/
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupContentView()
        setupTitleLabel()
        self.roundCorners([.topLeft, .topRight], radius: 10)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    private func setupContentView() {
        contentView = UIView()
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            // 自动布局
            make.centerY.equalToSuperview()
            make.left.equalTo(Constant.margin * 1.5)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension EssayCardListSectionHeaderView {
    
    func setupColor(bgColor: UIColor, contentColor: UIColor) {
        self.backgroundColor = bgColor
        self.contentView.backgroundColor = contentColor
    }
    
    func setupTitle(_ title: String, index: Int) {
        self.titleLabel.text = title
        self.index = index
    }
    
    @objc
    func tapAction() {
        headerHandle?(index)
    }
}

