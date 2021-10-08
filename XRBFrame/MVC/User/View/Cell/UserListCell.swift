//
//  UserListCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/12.
//

import UIKit

class UserListCell: UITableViewCell {
    //MARK: - 标识符
    static let identifier = "UserListCell"
    
    //MARK: - 全局变量
    private var index: Int?
    private var titlelabel: UILabel!
    private var subTitlelabel: UILabel!
    private var indexButton: UIButton!
    private var entity: UserListEntity?
    
    var actionHandle: ((Int) -> Void)? = nil
    
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
        
        setupIndexButton()
        setupTitleLabel()
        setupSubTitleLabel()
    }
    
    private func setupIndexButton() {
        indexButton = UIButton()
        indexButton.setTitleColor(.white, for: UIControl.State.normal)
        indexButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        indexButton.backgroundColor = UIColor.orange
        indexButton.setCornerRadius(8)
        indexButton.addTarget(self, action: #selector(btnAction), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(indexButton)
        indexButton.snp.makeConstraints { (make) in
            // 自动布局
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(60)
        }
    }
    
    private func setupTitleLabel() {
        titlelabel = UILabel()
        titlelabel.textAlignment = .left
        titlelabel.textColor = .black
        titlelabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.contentView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.equalTo(indexButton.snp.left).offset(-10)
        }
    }
    
    private func setupSubTitleLabel() {
        subTitlelabel = UILabel()
        subTitlelabel.textAlignment = .left
        subTitlelabel.textColor = .black
        subTitlelabel.numberOfLines = 0
        subTitlelabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.contentView.addSubview(subTitlelabel)
        subTitlelabel.snp.makeConstraints { (make) in
            // 自动布局
            make.left.right.equalTo(titlelabel)
            make.top.equalTo(titlelabel.snp.bottom).offset(10)
            make.bottom.equalTo(-20)
        }
       
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension UserListCell {
    /// 数据填充
    func show(entity: UserListEntity, index: Int) {
        self.entity = entity
        self.index = index
        
        titlelabel.text = entity.title
        subTitlelabel.text = entity.subTitle
        indexButton.setTitle("按钮\(index)", for: .normal)
        
        titlelabel.snp.remakeConstraints { (make) in
            // 自动布局
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.equalTo(indexButton.snp.left).offset(-10)
        }
        
        subTitlelabel.snp.remakeConstraints { (make) in
            // 自动布局
            make.left.right.equalTo(titlelabel)
            make.top.equalTo(titlelabel.snp.bottom).offset(10)
            make.bottom.equalTo(-20)
        }
    }
    
    // 按钮点击事件
    @objc private func btnAction() {
        actionHandle?(self.index ?? 0)
    }
}
