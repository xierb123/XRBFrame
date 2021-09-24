//
//  UserViewController.swift
//  BasicProgram
//
//  Created by 谢汝滨 on 2020/9/11.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

class UserViewController: BaseViewController {
    
    //MARK: - 全局变量
    /// 状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    /// segmentedView高度
    private var headerInSectionHeight: Int = 44
    /// 头部高度
    private var tableHeaderViewHeight: Int = 260 {
        didSet {
            pagingView.resizeTableHeaderViewHeight()
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
    
    /// 分段视图
    private lazy var segmentedView: JXSegmentedView = {
        let frame = CGRect(x: 0.0, y: 0.0, width: Constant.screenWidth, height: CGFloat(headerInSectionHeight))
        let segmentedView = JXSegmentedView(frame: frame)
        segmentedView.backgroundColor = UIColor.clear
        segmentedView.dataSource = dataSource
        segmentedView.indicators = [indicatorLineView]
        let contentEdgeInset = (Constant.screenWidth - 120.0) / 2.0
        segmentedView.contentEdgeInsetLeft = contentEdgeInset
        segmentedView.contentEdgeInsetRight = contentEdgeInset
        segmentedView.delegate = self
        return segmentedView
    }()

    /// 用户信息头部
    private lazy var userInfoHeaderView: UserHeaderView = {
        let headerView = UserHeaderView()
        headerView.backgroundColor = .purple
        return headerView
    }()
    
    /// segmentedView数据源
    private lazy var dataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = ["作品", "喜欢"]
        dataSource.titleSelectedColor = UIColor.white
        dataSource.titleNormalColor = UIColor.white.withAlphaComponent(0.6)
        dataSource.titleNormalFont = UIFont.systemFont(ofSize: 16.0)
        dataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 16.0)
        return dataSource
    }()
    
    /// segmentedView指示器（选项底部线）
    private lazy var indicatorLineView: JXSegmentedIndicatorLineView = {
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = Color.theme
        lineView.indicatorWidth = 14.0
        lineView.indicatorHeight = 3.0
        lineView.indicatorCornerRadius = 1.5
        lineView.verticalOffset = 3.0
        return lineView
    }()
    
    /// 我的作品
    private lazy var myWorksVC: WorkViewController = {
        let entity = UserListEntity(title: "追龙", subTitle: "《追龙》是由银都机构有限公司出品的动作犯罪片，由王晶、关智耀执导，甄子丹领衔主演、刘德华特别演出、郑则仕、姜皓文、刘浩龙、胡然、徐冬冬等联合主演。该片于2017年9月30日在中国内地上映。该片讲述了能打敢拼的伍世豪从汕头偷渡来到香港为了长久生存之道，他与心思缜密的探长雷洛联手制霸香港的故事。")
        var dataList = [UserListEntity]()
        for item in 0...9{
            dataList.append(entity)
        }
        let myWorksVC = WorkViewController(parameters: ["dataList": dataList])
        return myWorksVC
    }()
    
    /// 喜欢的作品
    private lazy var favoriteWorksVC: WorkViewController = {
        let entity = UserListEntity(title: "追龙", subTitle: "《追龙》是由银都机构有限公司出品的动作犯罪片，由王晶、关智耀执导，甄子丹领衔主演、刘德华特别演出、郑则仕、姜皓文、刘浩龙、胡然、徐冬冬等联合主演。该片于2017年9月30日在中国内地上映。该片讲述了能打敢拼的伍世豪从汕头偷渡来到香港为了长久生存之道，他与心思缜密的探长雷洛联手制霸香港的故事。")
        var dataList = [UserListEntity]()
        for item in 0...9{
            dataList.append(entity)
        }
        let myWorksVC = WorkViewController(parameters: ["dataList": dataList])
        return myWorksVC
    }()
   
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        self.isNavigationBarHidden = true
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupHeaderView() {
        
    }
    
    
    //MARK: - UI布局
    private func setupView() {
        setupHeaderView()
        view.backgroundColor = UIColor(hexString: "#1E2026")
        view.addSubview(pagingView)
        
        segmentedView.listContainer = pagingView.listContainerView
        pagingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension UserViewController {
    
}

//MARK: - 数据请求
extension UserViewController {
    
}

//MARK: - Tabbar代理协议
extension UserViewController: TabbarRefreshTargetProtocol {
    func refreshTarget() {
        printLog("我的 - 页面刷新")
    }
}

extension UserViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

extension UserViewController: JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return tableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userInfoHeaderView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return headerInSectionHeight
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return dataSource.titles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        return index == 0 ? myWorksVC : favoriteWorksVC
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
//        self.view.insertSubview(pagingView, at: 10)
        self.view.insertSubview(userInfoHeaderView, at: 0)
        userInfoHeaderView.y = -scrollView.contentOffset.y/2
       
        // 处理导航栏的透明度
        let thresholdDistance: CGFloat = Constant.navigationHeight * 2.0
        var percent = scrollView.contentOffset.y / thresholdDistance
        percent = max(0.0, min(percent, 1.0))
        //customNavigationBar.backgroundView.alpha = percent
        //userInfoHeaderView.alpha = 1-percent
        segmentedView.alpha = 1-percent
    }
}

extension UserViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 禁止segmentedView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}







