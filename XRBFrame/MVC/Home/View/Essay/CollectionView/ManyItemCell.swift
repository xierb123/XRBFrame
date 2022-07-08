//
//  ManyItemCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/28.
//
//  多条cell

import UIKit

class ManyItemCell: UICollectionViewCell {
    //MARK: - 标识符
    static let identifier = "ManyItemCell"
    
    //MARK: - 全局变量
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var model: BannerEntity!
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
        self.layer.borderColor = UIColor.purple.cgColor
        self.layer.borderWidth = 2
        self.setCornerRadius(4, masksToBounds: true)
        setupImageView()
        setupTitleLabel()
    }
    
    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            // 自动布局
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = Color.theme
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            // 自动布局
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension ManyItemCell: BindData {
    /// 数据绑定
    func bindData(_ data: Any?) {
        if let viewModel = data as? BannerEntity {
            self.model = viewModel
            self.titleLabel.text = viewModel.title
            self.imageView.image = UIImage(named: viewModel.imageName)
        }
    }
}


