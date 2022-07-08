//
//  AnimationForPresentViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/28.
//
//  PresentView转场动画页面

import UIKit
import EmptyDataSet_Swift

class AnimationForPresentViewController: BaseViewController {
    
    //MARK: - 全局变量
    var collectionViewProtocol: CollectionViewProtocol?
    var dataArr:Array<CollectionSectionViewModel> = []
    
    //MARK: - 懒加载
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(hexString: "#F5F5F5")
        return collectionView
    }()
    
    //MARK: - init/deinit方法
//    init(parameters: [String : Any]? = nil) {
//        super.init(parameters: parameters)
//        
//    }
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSimulationData()
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension AnimationForPresentViewController {
    
}

//MARK: - 数据请求
extension AnimationForPresentViewController {
    
    /// 设置模拟数据
    private func setupSimulationData() {
        var demoData = [
            AnimationForPresentListEntity(imageName: "ic_address_empty", time: "08:43", title: "这是一条测试视频,名称是视频1", userImage: "ic_address_empty", userName: "测试用户1", collectionTime: ""),
            AnimationForPresentListEntity(imageName: "ic_address_empty", time: "08:43", title: "这是一条测试视频,名称是视频2", userImage: "ic_address_empty", userName: "测试用户2", collectionTime: ""),
            AnimationForPresentListEntity(imageName: "ic_address_empty", time: "08:43", title: "这是一条测试视频,名称是视频3", userImage: "ic_address_empty", userName: "测试用户3", collectionTime: ""),
            AnimationForPresentListEntity(imageName: "ic_address_empty", time: "08:43", title: "这是一条测试视频,名称是视频4", userImage: "ic_address_empty", userName: "测试用户4", collectionTime: ""),
            AnimationForPresentListEntity(imageName: "ic_address_empty", time: "08:43", title: "这是一条测试视频,名称是视频5", userImage: "ic_address_empty", userName: "测试用户5", collectionTime: ""),
            ]
        
        
        var viewModel = CollectionSectionViewModel(type: AnimationForPresentListCell.identifier)
        viewModel.minimumLineSpacing = 10
        viewModel.minimumInteritemSpacing = 10
        viewModel.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        viewModel.itemIdentifier = AnimationForPresentListCell.identifier
        viewModel.itemSize = CGSize(width: (Constant.screenWidth-30)/2, height: (Constant.screenWidth-30)*0.8)
        viewModel.itemViewModels =  demoData
        dataArr.append(viewModel)
        
        collectionViewProtocol = collectionView.bindData(dataArr)
        collectionView.reloadDataWithoutFlicker()
    }
}

//MARK: - 选择器事件(自定义方法)
extension AnimationForPresentViewController {
    override func routerEvent(_ event: RouterEvent?) {
        
        if let event = event as? Comment {
            if case CellEvent.clicked(let data as AnimationForPresentListEntity) = event.event {
                if event.type == AnimationForPresentListCell.identifier {
                    presentVC()
                }
            }
        }
        super.routerEvent(event)
    }
    
    private func presentVC() {
        let listVC = AnimationListViewController()
        listVC.modalPresentationStyle = .overCurrentContext
        present(listVC, animated: true)
    }
}
