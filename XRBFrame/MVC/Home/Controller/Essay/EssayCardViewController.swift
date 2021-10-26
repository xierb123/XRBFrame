//
//  EssayCardViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/22.
//
//  卡片样式

import UIKit
import JXPagingView

class EssayCardViewController: BaseViewController {
    
    /// segmentedView高度
    private var headerInSectionHeight: Int = 100
    /// 头部高度
    private var tableHeaderViewHeight: Int = 200  {
        didSet {
            //pagingView.resizeTableHeaderViewHeight()
        }
    }
    
    //MARK: - 懒加载
    /// 多页面可滚动视图
    private lazy var pagingView: JXPagingView = {
        let pagingView = JXPagingListRefreshView(delegate: self, listContainerType: .scrollView)
        pagingView.backgroundColor = UIColor.clear
        pagingView.listContainerView.backgroundColor = UIColor.clear
        pagingView.listContainerView.listCellBackgroundColor = UIColor.clear
        pagingView.mainTableView.backgroundColor = UIColor.clear
        pagingView.mainTableView.gestureDelegate = self
        pagingView.pinSectionHeaderVerticalOffset = Int(Constant.statusBarHeight)
        return pagingView
    }()
    
    /// 我的作品
    private lazy var myWorksVC: EssayCardListViewController = {
        var simulationData: [Any] {
            let data1 = ["title": "条目一", "list": [1,2,3,4,5,6,7]] as [String : Any]
            let data2 = ["title": "条目二", "list": [1,2,3,4]] as [String : Any]
            let data3 = ["title": "条目三", "list": [1,2,3,4,5,6,7,8,9]] as [String : Any]
            
            return [data1, data2, data3]
        }
        let myWorksVC = EssayCardListViewController(parameters: ["simulationData": simulationData])
        return myWorksVC
    }()
    

    /// 用户信息头部
    private lazy var userInfoHeaderView: UserHeaderView = {
        let headerView = UserHeaderView()
        headerView.backgroundColor = .purple
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    //MARK: - UI布局
    private func setupView() {
        view.backgroundColor = UIColor(hexString: "#1E2026")
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


extension EssayCardViewController: JXPagingViewDelegate {
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return UIView()
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return tableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userInfoHeaderView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return headerInSectionHeight
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return 1
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        return myWorksVC
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        
        self.view.insertSubview(userInfoHeaderView, at: 0)
        userInfoHeaderView.y = -scrollView.contentOffset.y
        
       
        // 处理导航栏的透明度
        let thresholdDistance: CGFloat = Constant.navigationHeight * 2.0
        var percent = scrollView.contentOffset.y / thresholdDistance
        percent = max(0.0, min(percent, 1.0))
        //customNavigationBar.backgroundView.alpha = percent
        //userInfoHeaderView.alpha = 1-percent
        //segmentedView.alpha = 1-percent
    }
}

extension EssayCardViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 禁止segmentedView左右滑动的时候，上下和左右都可以滚动
        
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}
