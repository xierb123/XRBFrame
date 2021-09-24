//
//  HotSearchListCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/23.
//
//  热门搜索cell

import UIKit

class HotSearchListCell: UICollectionViewCell {
    //MARK: - 标识符
    static let identifier = "HotSearchListCell"
    
    //MARK: - 全局变量
    /// 索引值
    private var index: Int = 0
    /// 标签label
    private var titleLabel: UILabel!
    /// 索引图标
    private var indexIcon: UIImageView!
    /// 数据模型
    private var entity: SearchEntity?
    
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
        // 设置UI
        setupIndexIcon()
        setupTitleLabel()
    }
    
    private func setupIndexIcon() {
        indexIcon = UIImageView()
        contentView.addSubview(indexIcon)
        indexIcon.snp.makeConstraints { (make) in
            make.left.equalTo(Constant.margin)
            make.width.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(indexIcon.snp.right).offset(5)
            make.right.equalTo(-12)
            make.height.centerY.equalTo(indexIcon)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension HotSearchListCell {
    /// 数据填充
    func show(entity: SearchEntity, index: Int) {
        self.entity = entity
        self.index = index
        
        let iconString = ["ic_hot_first","ic_hot_second","ic_hot_third"]
        if index <= 2{
            indexIcon.snp.updateConstraints { (make) in
                make.width.equalTo(14)
                make.left.equalTo(12)
            }
            indexIcon.image = UIImage(named: iconString[index])
            titleLabel.text = entity.searchName
            titleLabel.textColor = UIColor(hexString: "#1A1A1A")
            titleLabel.font = UIFont.systemFont(ofSize: 14)
        } else {
            indexIcon.snp.updateConstraints { (make) in
                make.width.equalTo(0)
                make.left.equalTo(7)
            }
            let attributeString = NSMutableAttributedString(string:"\(index+1). \(entity.searchName)")
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor(hexString: "#8C8C8C")!,range: NSMakeRange(0,2))
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor(hexString: "#1A1A1A")!,range: NSMakeRange(3,entity.searchName.count))
            titleLabel.attributedText = attributeString
        }
    }
}
