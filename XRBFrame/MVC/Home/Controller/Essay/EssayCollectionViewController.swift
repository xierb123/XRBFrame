//
//  EssayCollectionViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/28.
//
//  爱宠collectionView列表绑定页面

import UIKit

class EssayCollectionViewController: BaseViewController {
    
    //MARK: - 全局变量
    /// 数据数组
    var dataArr:Array<CollectionSectionViewModel> = Array()
    /// 封装列表协议
    var collectionViewProtocol: CollectionViewProtocol?
    
    //MARK: - 懒加载
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(hexString: "#F5F5F5")
        
        return collectionView
    }()
    
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSimulationData()
        
    }
    
    //MARK: - UI布局
    private func setupView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


//MARK: - 数据请求
extension EssayCollectionViewController {
    
    ///  模拟数据
    private func setupSimulationData() {
        simulationDataForBanner()
        simulationDataForSingleItem()
        simulationDataForManyItem()
        
        collectionViewProtocol = collectionView.bindData(dataArr)
        collectionView.reloadDataWithoutFlicker()
    }
    
    /// 模拟banner数据
    private func simulationDataForBanner() {
        let data = [
            BannerEntity(title: "测试数据1", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据2", imageName: "ic_address_empty")
        ]
        
        var viewModel = CollectionSectionViewModel(type: BannerCell.identifier)
        viewModel.minimumLineSpacing      = 0
        viewModel.minimumInteritemSpacing = 0
        viewModel.itemIdentifier = BannerCell.identifier
        viewModel.itemSize = CGSize(width:Constant.screenWidth , height:170)
        var cellViewModel = CellViewModel()
        cellViewModel.data = data
        viewModel.itemViewModels =  [cellViewModel as Any]
        dataArr.append(viewModel)
    }
    
    /// 模拟包含段头/段尾的单条cell数据(单条数据里面包含数组展示)
    private func simulationDataForSingleItem() {
        let headerData = BannerEntity(title: "段头数据", imageName: "ic_address_empty")
        let footerData = BannerEntity(title: "到这就没有啦~", imageName: "ic_address_empty")
        let cellData = [
            BannerEntity(title: "测试数据1", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据2", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据3", imageName: "ic_address_empty")
        ]
        
        var viewModel = CollectionSectionViewModel(type: SingleItemCell.identifier)
        viewModel.headerIdentifier = SingleHeaderView.identifier
        viewModel.headerSize = CGSize(width:Constant.screenWidth , height:50)
        viewModel.headerViewModel = headerData
        
        viewModel.footerIdentifier = SingleFooterView.identifier
        viewModel.footerSize = CGSize(width:Constant.screenWidth , height:50)
        viewModel.footerViewModel = footerData
        
        viewModel.minimumLineSpacing      = 0
        viewModel.minimumInteritemSpacing = 0
        viewModel.itemIdentifier = SingleItemCell.identifier
        viewModel.itemSize       = CGSize(width:Constant.screenWidth , height:170)
        var cellViewModel = CellViewModel()
        cellViewModel.data = cellData
        viewModel.itemViewModels =  [cellViewModel as Any]
        dataArr.append(viewModel)
    }
    
    /// 模拟包含段头/段尾的多条cell数据
    private func simulationDataForManyItem() {
        let data = [
            BannerEntity(title: "测试数据1", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据2", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据3", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据4", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据5", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据6", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据7", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据8", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据9", imageName: "ic_address_empty"),
            BannerEntity(title: "测试数据10", imageName: "ic_address_empty")
        ]
        
        
        var viewModel = CollectionSectionViewModel(type: ManyItemCell.identifier)
        viewModel.minimumLineSpacing      = 10
        viewModel.minimumInteritemSpacing = 10
        viewModel.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        viewModel.itemIdentifier = ManyItemCell.identifier
        viewModel.itemSize = CGSize(width:(Constant.screenWidth-30) / 2 , height:170)
        viewModel.itemViewModels =  data
        dataArr.append(viewModel)

    }
}

//MARK: - 选择器事件(自定义方法)
extension EssayCollectionViewController {
    override func routerEvent(_ event: RouterEvent?) {
        
        if let event = event as? Comment {
            if case CellEvent.clicked(let index as Int) = event.event  {
                if event.type == BannerCell.identifier { // banner
                    printLog("点击了第\(index)个banner图片")
                }
                
                if event.type == SingleItemCell.identifier { // 单个cell里面的点击事件
                    printLog("点击了单个cell的第\(index)个图片")
                }
            }
            
            if case CellEvent.clicked(let data as BannerEntity) = event.event {
                if event.type == ManyItemCell.identifier {
                    printLog("点击了多个cell的其中一个cell, 展示内容为\(data.title)")
                }
            }
        }
        super.routerEvent(event)
    }
}




