//
//  SearchContentView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/23.
//
//  热门搜索视图组件

import UIKit
import EmptyDataSet_Swift

class SearchContentView: UIView {
    
    //MARK: - 回调方法
    var searchKeyHandle: ((SearchEntity) -> Void)? = nil
    
    //MARK: - 全局变量
    private var entities = [SearchEntity]() {
        didSet{
            collectionView.reloadDataWithoutFlicker()
        }
    }
    
    //MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: Constant.screenWidth/2, height: 42)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.register(HotSearchListCell.self, forCellWithReuseIdentifier: HotSearchListCell.identifier)
        collectionView.register(SearchSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchSectionHeaderView.identifier)
        
        return collectionView
    }()
    
    //MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    /*init(<#parameter#>: <#Object#>) {
     super.init(frame: .zero)
     
     setupView()
     }*/
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension SearchContentView {
    func setEntities(with entities: [SearchEntity]) {
        self.entities = entities
    }
}

//MARK: - CollectionView代理协议
extension SearchContentView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotSearchListCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? HotSearchListCell, indexPath.row < entities.count else {
            return
        }
        cell.show(entity: entities[indexPath.item], index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < entities.count else {
            return
        }
        // 点击事件
        searchKeyHandle?(entities[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind.isEqual(UICollectionView.elementKindSectionHeader) {
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchSectionHeaderView.identifier, for: indexPath) as! SearchSectionHeaderView
            return sectionHeaderView
        } else if kind.isEqual(UICollectionView.elementKindSectionFooter) {
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height:CGFloat = entities.count > 0 ? 33 : 0
        return CGSize(width: collectionView.width, height: height)
    }
}
//MARK: - 代理协议,空数据保护
extension SearchContentView: EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return EmptyDataPage.default.title
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return EmptyDataPage.default.image
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return EmptyDataPage.default.verticalOffset
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return EmptyDataPage.default.spaceHeight
    }
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return EmptyDataPage.default.buttonImage
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        // 点击事件
    }
}
//MARK: - 代理协议,空数据保护
extension SearchContentView: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return entities.isEmpty
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return EmptyDataPage.default.allowScroll
    }
}

