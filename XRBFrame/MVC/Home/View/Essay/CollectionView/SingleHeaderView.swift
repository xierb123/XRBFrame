//
//  SingleHeaderView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/29.
//

//  单个cell的头部视图

import UIKit

class SingleHeaderView: UICollectionReusableView {
    //MARK: - 标识符
    static let identifier = "SingleHeaderView"
    
    //MARK: - 全局变量
    private var iconImageView: UIImageView!
    private var titlelabel: UILabel!
    private var model: BannerEntity?
    private var index: Int?
    
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
        self.backgroundColor = Color.theme
        setupIcon()
        setupTitleLabel()
    }
    
    private func setupIcon() {
        iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "bt_defaultaddress_selected")
        iconImageView.contentMode = .scaleAspectFit
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(Constant.margin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    private func setupTitleLabel() {
        titlelabel = UILabel()
        titlelabel.textAlignment = .left
        titlelabel.textColor = .white
        titlelabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(iconImageView.snp.right).offset(Constant.margin)
            make.centerY.equalToSuperview()
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension SingleHeaderView: BindData {
    /// 数据填充
    func bindData(_ data: Any?) {
        if let viewModel = data as? BannerEntity {
            self.model = viewModel
            self.titlelabel.text = viewModel.title
        }
    }
}

