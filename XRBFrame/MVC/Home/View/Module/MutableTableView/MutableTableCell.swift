//
//  MutableTableCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/9.
//
//  多样化列表当中的collection列表cell

import UIKit


class MutableTableCell: UITableViewCell {
    //MARK: - 标识符
    static let identifier = "MutableCollectionCell"
    
    //MARK: - 回调方法
    var collectionCellHandle: ((Int, UserListEntity) -> ())? = nil
    
    //MARK: - 全局变量
    private var collectionView: UICollectionView!
    private var entities: [UserListEntity]!
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
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: Constant.screenWidth, height: 160)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 200), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        //collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(MutableSubCollectionCell.self, forCellWithReuseIdentifier: MutableSubCollectionCell.identifier)
        self.contentView.addSubview(collectionView)
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - CollectionView代理协议
extension MutableTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MutableSubCollectionCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MutableSubCollectionCell, indexPath.row < entities.count else {
            return
        }
        cell.show(entity: entities[indexPath.item], index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < entities.count else {
            return
        }
        // 点击事件
        collectionCellHandle?(indexPath.item, entities[indexPath.item])
    }
}

//MARK: - 选择器事件(自定义方法)
extension MutableTableCell {
    /// 数据填充
    func show(entities: [UserListEntity]) {
        self.entities = entities
        collectionView.reloadDataWithoutFlicker()
    }
}

// MARK: ******************************  分割线  ******************************

//  子类CollectionCell

import UIKit

class MutableSubCollectionCell: UICollectionViewCell {
    //MARK: - 标识符
    static let identifier = "MutableSubCollectionCell"
    
    //MARK: - 全局变量
    private var titleLable: UILabel!
    private var detailLabel: UILabel!
    private var entity: UserListEntity?
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
        setupTitleLabel()
        setupDetailLabel()
    }
    
    private func setupTitleLabel() {
        titleLable = UILabel()
        titleLable.textAlignment = .left
        titleLable.textColor = .darkGray
        titleLable.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        self.contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            // 自动布局
            make.left.top.equalTo(Constant.margin*1.5)
            make.right.equalTo(-Constant.margin*1.5)
        }
    }
    
    private func setupDetailLabel() {
        detailLabel = UILabel()
        detailLabel.textAlignment = .left
        detailLabel.textColor = .gray
        detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        detailLabel.numberOfLines = 0
        self.contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            // 自动布局
            make.left.bottom.equalTo(Constant.margin*1.5)
            make.right.equalTo(titleLable)
            make.top.equalTo(titleLable.snp.bottom).offset(Constant.margin)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension MutableSubCollectionCell {
    /// 数据填充
    func show(entity: UserListEntity, index: Int) {
        self.entity = entity
        self.index = index
        
        titleLable.text = "\(entity.title) \(index)"
        detailLabel.text = entity.subTitle
    }
}




