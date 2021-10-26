//
//  EssayCardListCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/22.
//
//  卡片子列表cell

import UIKit

class EssayCardListCell: UITableViewCell {
    //MARK: - 标识符
    static let identifier = "EssayCardListCell"
    
    //MARK: - 全局变量
    private var bgImage: UIImageView!
    private var titleLabel: UILabel!
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
        
        setupBGImage()
        setupTitleLabel()
    }
    
    private func setupBGImage() {
        bgImage = UIImageView()
        bgImage.image = UIImage(named: "bg_dengluye")
        bgImage.contentMode = .scaleAspectFill
        bgImage.setCornerRadius(10, masksToBounds: true)
        self.contentView.addSubview(bgImage)
        bgImage.snp.makeConstraints { (make) in
            // 自动布局
            make.left.top.equalTo(Constant.margin)
            make.right.bottom.equalTo(-Constant.margin)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bgImage.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            // 自动布局
            make.center.equalToSuperview()
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension EssayCardListCell {
    /// 数据填充
    func show(index: Int) {
       
        self.index = index
        titleLabel.text = "我是一个兵 - \(index)"
    }
}
