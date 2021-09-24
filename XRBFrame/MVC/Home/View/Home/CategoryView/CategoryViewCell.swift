//
//  CategoryViewCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/20.
//
//  类别cell

import UIKit

class CategoryViewCell: UICollectionViewCell {
    //MARK: - 标识符
    static let identifier = "CategoryViewCell"
    
    //MARK: - 全局变量
    private var entity: CategoryEntity?
    private var index: Int?
    var edite = true {
        didSet {
            imageView.isHidden = !edite || index == 1
        }
    }
    
    private var text: String? {
        didSet {
            label.text = text
        }
    }
    
    //MARK: - 懒加载
    private lazy var label: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var imageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: self.width-14, y: 4, width: 10, height: 10))
        image.image = UIImage(named: "ic_pop_close")
        image.isHidden = true
        return image
    }()
    
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
        contentView.addSubview(label)
        label.addSubview(imageView)
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension CategoryViewCell {
    /// 数据填充
    func show(entity: CategoryEntity?, index: Int) {
        self.entity = entity
        self.text = entity?.name ?? ""
        self.index = index
    }
    
    /// 获取当前cell的数据模型
    func getEntity() -> CategoryEntity? {
        return self.entity
    }
    
    /// 设置关闭按钮的显隐情况
    func showImageView(with show: Bool) {
        imageView.isHidden = !show
    }
}


