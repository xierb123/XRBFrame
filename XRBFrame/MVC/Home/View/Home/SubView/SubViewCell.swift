//
//  SubViewCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/24.
//
//  分类页面列表cell

import UIKit

class SubViewCell: UITableViewCell {
    //MARK: - 标识符
    static let identifier = "SubViewCell"
    
    //MARK: - 全局变量
    private var titleLabel: UILabel!
    private var title: String?
    private var index: Int?
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        // 设置UI
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(Constant.margin*1.8)
            make.right.equalTo(-Constant.margin*1.8)
            make.top.bottom.equalToSuperview()
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension SubViewCell {
    /// 数据填充
    func show(title: String, index: Int) {
        self.title = title
        self.index = index
        
        self.titleLabel.text = title
    }
    
    // 动画效果
    func cellAnimation() {
        titleLabel.transform = CGAffineTransform(translationX: 100, y: 0)
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}
