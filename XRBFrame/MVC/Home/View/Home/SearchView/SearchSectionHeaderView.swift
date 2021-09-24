//
//  SearchSectionHeaderView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/23.
//
//  热门搜索段头视图组件

import UIKit


class SearchSectionHeaderView: CustomCollectionReusableView {
    //MARK: - 标识符
    static let identifier = "SearchSectionHeaderView"
    
    //MARK: - 全局变量
    private var titleLabel: UILabel!
    
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
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.text = "热门搜索"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(Constant.margin)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(100)
            make.height.equalTo(16)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension SearchSectionHeaderView {
    
}

