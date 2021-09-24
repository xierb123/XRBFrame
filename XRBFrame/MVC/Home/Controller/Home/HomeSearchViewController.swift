//
//  HomeSearchViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/23.
//
//  搜索页面

import UIKit
import EmptyDataSet_Swift

class HomeSearchViewController: BaseViewController {
    
    //MARK: - 全局变量
    /// 搜索词
    private var searchKey: String = ""
    /// 热门搜索数据源
    private var hotSearchEntities = [SearchEntity]()
    /// 历史搜索数据源
    private var historyEntities = [SearchEntity]() {
        didSet {
            resetHeaderView()
        }
    }
    /// 子页面管理器
    private var pageViewManager: PageViewManager?
    
    //MARK: - 懒加载
    /// 自定义导航条
    private lazy var customNavigationBar: SearchCustomNavigationBar = {
        let customNavigationBar = SearchCustomNavigationBar(placeHolder: searchKey)
        customNavigationBar.backHandle = { [weak self] in
            self?.backAction()
        }
        customNavigationBar.clearHandle = { [weak self] in
            self?.setSearchViewHide(with: false)
        }
        customNavigationBar.searchHandle = { [weak self] (entity) in
            print("开始搜索 - \(entity)")
            self?.addHistory(with: entity)
        }
        return customNavigationBar
    }()
    
    /// 头视图
    private lazy var headerView: SearchHeaderView = {
        let headerView = SearchHeaderView()
        headerView.clearHandle = { [weak self] in
            print("清除")
            self?.clearHidtory()
        }
        headerView.tagHandle = { [weak self] (entity) in
            print(entity)
            self?.addHistory(with: entity)
        }
        return headerView
    }()
    
    /// 热门搜索视图
    private lazy var contentView: SearchContentView = {
        let contentView = SearchContentView()
        contentView.searchKeyHandle = { [weak self] (entity) in
            print(entity)
            self?.addHistory(with: entity)
        }
        return contentView
    }()
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        self.isNavigationBarHidden = true
        
        if let searchKey = parameters?["searchKey"] as? String {
            self.searchKey = searchKey
            print("跳转到搜索页面,搜索关键词-\(searchKey)")
        } else {
            print("跳转到搜索页面,不包含搜索关键词")
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        getHistory()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.simulateData()
        }
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupCustomNavigationBar()
        setupHeaderView()
        setupContentView()
    }
    
    private func setupCustomNavigationBar() {
        self.view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Constant.navigationHeight)
        }
    }
    
    private func setupHeaderView() {
        self.view.addSubview(headerView)
        headerView.backgroundColor = .white
        headerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.height.equalTo(0)
        }
    }
    
    private func resetHeaderView() {
        var titles = [String]()
        historyEntities.forEach { (item) in
            let entity = item
            titles.append(entity.searchName)
        }
        headerView.showLabels(titles: titles)
        headerView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(customNavigationBar.snp.bottom)
            if historyEntities.count <= 0 { make.height.equalTo(0) }
        }
    }
    
    private func setupContentView() {
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    // 设置分页视图
    private func setupPageViewControllers(categories: [CategoryEntity]) {
        let style = PageStyle()
        style.isShowBubble = true
        style.isBubbleScrollable = true
        style.isShowBottomLine = true
        style.isTitleScaleEnabled = true
        style.isShowRightSideMask = false
        style.rightSideMaskLayerColor = .red
        style.isTitleViewScrollEnabled = true
        style.titleColor = UIColor(hexString: "#666666")
        style.titleSelectedColor = UIColor(hexString: "#1D1D1F")
        style.isSelectedTitleBold = true
        style.titleFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        style.titleMaximumScaleFactor = 1.1
        style.titleMargin = 20.0
        style.titleViewTopPadding = 12.0
        style.titleViewInsets = PageTitleEdgeInsets(left: 28.0, right: style.rightSideMaskWidth)
        style.bottomLineWidth = 12.0
        style.bottomLineHeight = 4.0
        style.bottomLineCornerRadius = 2.0
        style.bottomLineColor = Color.theme
        style.bubbleSize = 10.0
        style.bubbleWidth = 2.0
        
        let startIndex: Int = 0
        var titles: [String] = ["全部"]
        // 添加默认页
        let searchMainVC = BaseViewController()
        searchMainVC.view.backgroundColor = UIColor.random
        addChild(searchMainVC)
        
        for index in 0..<categories.count {
            titles.append(categories[index].name)
            let searchListVC = BaseViewController()
            searchListVC.view.backgroundColor = UIColor.random
            addChild(searchListVC)
        }
        
        pageViewManager = PageViewManager(style: style, titles: titles, childViewControllers: children, startIndex: startIndex)
        if let titleView = pageViewManager?.titleView, let contentView = pageViewManager?.contentView {
            self.view.addSubview(titleView)
            self.view.addSubview(contentView)
            
            titleView.snp.makeConstraints { (make) in
                make.left.width.equalToSuperview()
                make.top.equalTo(customNavigationBar.snp.bottom)
                make.height.equalTo(38)
            }
            
            contentView.snp.makeConstraints { (make) in
                make.top.equalTo(titleView.snp.bottom)
                make.left.width.bottom.equalToSuperview()
            }
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension HomeSearchViewController {
    // 返回上层
    private func backAction() {
        SearchManager.clearAll { [weak self] in
            guard let self = self else {return}
            SearchManager.addRecords(self.historyEntities)
        }
        clickBackBtn()
    }
    // 新增搜索历史数据
    private func addHistory(with entity: SearchEntity) {
        self.view.endEditing(true)
        self.searchKey = ""
        // 去除空数据
        guard !entity.searchName.isBlank else {
            print("内容为空")
            return
        }
        // 去重处理(先将重复数据移除,然后重新插入到数组顶部)
        if historyEntities.contains(entity) {
            print("去重处理")
            historyEntities.removeAll { repetEntity in
                return repetEntity == entity
            }
        }
        // 添加数据
        historyEntities.append(entity)
        customNavigationBar.setSearchKey(entity.searchName)
        print("开始网络请求数据")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.setSearchViewHide(with: true)
            setDataForResult()
        }
        func setDataForResult() {
            var categories = [CategoryEntity]()
            for item in 0...3 {
                let entity = CategoryEntity(classifyKey: "1111", name: "分类\(item+1)", parentKey: "11111")
                categories.append(entity)
            }
            setupPageViewControllers(categories: categories)
        }
    }
    
    // 清空历史数据
    private func clearHidtory() {
        self.showAlert(type: .alert, title: "", message: "确认删除全部历史搜索吗？", sourceView: nil, actions: [
            AlertAction(title: "取消", type: .cancel, handler: nil),
            AlertAction(title: "确认", type: .default, handler: { [weak self] () -> Void in
                guard let self = self else { return }
                self.historyEntities.removeAll()
            })
        ])
    }
    
    // 清除子页面
    private func clearSubViewAndChildren() {
        self.children.forEach { child in
            child.removeFromParent()
        }
        self.view.subviews.forEach { view in
            if view is PageTitleView || view is PageContentView {
                view.removeFromSuperview()
            }
        }
    }
    
    // 控制搜索组件显隐
    private func setSearchViewHide(with hide: Bool) {
        if !hide {
            clearSubViewAndChildren()
        }
        headerView.isHidden = hide
        contentView.isHidden = hide
    }
}

//MARK: - 数据请求
extension HomeSearchViewController {
    // 模拟热门搜索数据
    func simulateData() {
        for item in 0...9 {
            let entity = SearchEntity(searchName: "热门搜索 - \(item+1)")
            self.hotSearchEntities.append(entity)
        }
        contentView.setEntities(with: self.hotSearchEntities)
    }
    
    // 获取历史搜索数据
    func getHistory() {
        SearchManager.allRecords { [weak self] array in
            guard let self = self else {return}
            self.historyEntities = array
        }
    }
}
