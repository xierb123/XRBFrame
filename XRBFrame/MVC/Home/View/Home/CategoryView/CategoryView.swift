//
//  CategoryView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/20.
//
//  分类管理视图组件

import UIKit

class CategoryView: UIView {
    
    //MARK: - 回调方法
    var switchoverCallback: ((_ index: Int) -> ())? = nil
    
    //MARK: - 全局变量
    /// 编辑状态
    private var isEdite = false
    private var indexPath: IndexPath?
    private var targetIndexPath: IndexPath?
    /// 分段标题
    private var headerArr = [["切换频道","点击添加更多频道"],["长按拖动排序","点击添加更多频道"]]
    private var selectedCategories: [CategoryEntity]
    private var otherCategories: [CategoryEntity]
    
    //MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let layout = CategoryViewLayout()
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.identifier)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.identifier)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        collectionView.addGestureRecognizer(longPress)
        
        return collectionView
    }()
    
    /// 拖动的时候占位的cell
    private lazy var dragingItem: CategoryViewCell = {
        let cell = CategoryViewCell(frame: CGRect(x: 0, y: 0, width: CategoryViewLayout.itemW, height: CategoryViewLayout.itemW * 0.5))
        cell.isHidden = true
        return cell
    }()
    
    //MARK: - init/deinit
    init(selectedCategories: [CategoryEntity], otherCategories: [CategoryEntity]) {
        self.selectedCategories = selectedCategories
        self.otherCategories = otherCategories
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.addSubview(dragingItem)
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 长按事件
extension CategoryView {
    /// 长按事件
    @objc func longPressGesture(_ tap: UILongPressGestureRecognizer) {
        if !isEdite {
            isEdite = !isEdite
            collectionView.reloadData()
            return
        }
        let point = tap.location(in: collectionView)
        
        switch tap.state {
        case UIGestureRecognizer.State.began:
                dragBegan(point: point)
        case UIGestureRecognizer.State.changed:
                drageChanged(point: point)
        case UIGestureRecognizer.State.ended:
                drageEnded(point: point)
        case UIGestureRecognizer.State.cancelled:
                drageEnded(point: point)
            default: break
        }
    }

    /// 长按开始
    private func dragBegan(point: CGPoint) {
        indexPath = collectionView.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0
        {return}
        
        let item = collectionView.cellForItem(at: indexPath!) as? CategoryViewCell
        item?.isHidden = true
        dragingItem.isHidden = false
        dragingItem.frame = (item?.frame)!
        dragingItem.show(entity: item?.getEntity(), index: 0)
        dragingItem.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    /// 长按过程
    private func drageChanged(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
        dragingItem.center = point
        targetIndexPath = collectionView.indexPathForItem(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! > 0 || indexPath == targetIndexPath || targetIndexPath?.item == 0 {return}
        // 更新数据
        let obj = selectedCategories[indexPath!.item]
        selectedCategories.remove(at: indexPath!.row)
        selectedCategories.insert(obj, at: targetIndexPath!.item)
        //交换位置
        collectionView.moveItem(at: indexPath!, to: targetIndexPath!)
        indexPath = targetIndexPath
    }
    
    /// 长按结束
    private func drageEnded(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
        let endCell = collectionView.cellForItem(at: indexPath!)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.dragingItem.transform = CGAffineTransform.identity
            self.dragingItem.center = (endCell?.center)!
        }, completion: { (finish) -> () in
            endCell?.isHidden = false
            self.dragingItem.isHidden = true
            self.indexPath = nil
        })
    }
}

//MARK: - 选择器事件(自定义方法)
extension CategoryView {
    /// 更新数据, 采用了任务组保证线程操作完成后执行跳转操作
    func updateCategories(successHandle: (() -> ())? = nil) {
        let group = DispatchGroup()
        group.enter()
        CategoryManager.deleteAllRecords(key: .selectedCategories) { [weak self] in
            guard let self = self else {return}
            CategoryManager.addRecords(self.selectedCategories, key: .selectedCategories) { finished in
                group.leave()
            }
        }
        group.enter()
        CategoryManager.deleteAllRecords(key: .otherCategories) { [weak self] in
            guard let self = self else {return}
            CategoryManager.addRecords(self.otherCategories, key: .otherCategories) { finished in
                group.leave()
            }
        }
        group.notify(queue: .main) {
            successHandle?()
        }
    }
}

//MARK: - CollectionView代理协议
extension CategoryView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? selectedCategories.count : otherCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as! CategoryViewCell
        cell.show(entity: indexPath.section == 0 ? selectedCategories[indexPath.item] : otherCategories[indexPath.item], index: indexPath.section)
        cell.edite = (indexPath.section == 0 && indexPath.item == 0) ? false : isEdite
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            // 更新数据
            let obj = otherCategories[indexPath.item]
            otherCategories.remove(at: indexPath.item)
            selectedCategories.append(obj)
            collectionView.moveItem(at: indexPath, to: NSIndexPath(item: selectedCategories.count - 1, section: 0) as IndexPath)
            if let cell = collectionView.cellForItem(at: IndexPath(item: selectedCategories.count-1, section: 0)) as? CategoryViewCell {
                cell.showImageView(with: isEdite)
            }
        } else {
            if isEdite {
                if indexPath.item == 0 {return}
                // 更新数据
                let obj = selectedCategories[indexPath.item]
                selectedCategories.remove(at: indexPath.item)
                otherCategories.insert(obj, at: 0)
                collectionView.moveItem(at: indexPath, to: NSIndexPath(item: 0, section: 1) as IndexPath)
                if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 1)) as? CategoryViewCell {
                    cell.showImageView(with: false)
                }
                
            } else {
                switchoverCallback?(indexPath.item)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.identifier, for: indexPath) as! CategoryHeaderView
        header.text = isEdite ? headerArr[1][indexPath.section] : headerArr[0][indexPath.section]
        header.button.isSelected = isEdite
        if indexPath.section > 0 {header.button.isHidden = true} else {header.button.isHidden = false}
        
        header.clickCallback = {[weak self] in
            self?.isEdite = !(self?.isEdite)!
            collectionView.reloadData()
        }
        
        return header
    }
}

//MARK: - 自定义布局属性
class CategoryViewLayout: UICollectionViewFlowLayout {
    static let itemW: CGFloat = (Constant.screenWidth - 100) * 0.25
    override func prepare() {
        super.prepare()
        
        headerReferenceSize = CGSize(width: Constant.screenWidth, height: 40)
        itemSize = CGSize(width: CategoryViewLayout.itemW, height: CategoryViewLayout.itemW * 0.5)
        minimumLineSpacing = 15
        minimumInteritemSpacing = 20
        sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
}

