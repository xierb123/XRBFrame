//
//  SingleItemCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/28.
//
//  单条cell(单条数据里面包含数组展示)cell

import UIKit

class SingleItemCell: UICollectionViewCell {
    //MARK: - 标识符
    static let identifier = "SingleItemCell"
    
    
    //MARK: - 全局变量
    private var models: [BannerEntity]!{
        didSet{
            setupSubviews()
        }
    }
    
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
    }
    
    private func setupSubviews() {
        let max = models.count >= 3 ? 3 : models.count
        let width = (Constant.screenWidth - 40) / 3
        for index in 0..<max {
            let imageView = UIImageView(x: CGFloat(index)*Constant.screenWidth/3 + 10, y: 10, width: width, height: width)
            imageView.image = UIImage(named: models[index].imageName)
            imageView.tag = 10 + index
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapAction(_:))))
            self.contentView.addSubview(imageView)
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: 0, y: imageView.height-20, width: imageView.width, height: 20)
            titleLabel.textAlignment = .center
            titleLabel.text = models[index].title
            titleLabel.textColor = .red
            titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            imageView.addSubview(titleLabel)
        }
    }
    
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension SingleItemCell: BindData {
    @objc private func imageViewTapAction(_ tap: UITapGestureRecognizer) {
        let tag = (tap.view?.tag ?? 0)-10
        self.routerEvent(Comment(event: .clicked(tag), type: SingleItemCell.identifier))
    }
    
    /// 数据填充
    func bindData(_ data: Any?) {
        if let viewModel:CellViewModel = data as? CellViewModel{ // 数据是一个封装的模型
            if let models = viewModel.data as? [BannerEntity]{
                self.models = models
            }
        }
    }
}


