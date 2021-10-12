//
//  HomeViewController.swift
//  BasicProgram
//
//  Created by 谢汝滨 on 2020/9/11.
//  Copyright © 2020 HICON. All rights reserved.
//
//  首页

import UIKit
import EmptyDataSet_Swift

class HomeViewController: BaseViewController {
    
    //MARK: - 全局变量
    /// 类别数据
    private  var categoryEntities: [CategoryEntity] {
        get{
            return CategoryManager.selectedCategories()
        }
    }
    /// 子页面管理器
    private var pageViewManager: PageViewManager?
    
    //MARK: - 懒加载
    /// 自定义导航条
    private lazy var customNavigationBar: HomeCustomNavigationBar = {
        let customNavigationBar = HomeCustomNavigationBar()
        customNavigationBar.scanHandle = {
            print("跳转到扫描页面")
        }
        customNavigationBar.messageHandle = {
            print("初始化分类数据")
            CategoryManager.deleteAllRecords(key: .selectedCategories) { [weak self] in
                self?.addPageViewControllers(with: 1)
            }
            CategoryManager.deleteAllRecords(key: .otherCategories) { [weak self] in
                self?.setCustomNavigationBarMessageNum()
            }
        }
        customNavigationBar.editingBeginHandle = { [weak self] searchKey in
            guard let self = self else {return}
            let searchVC = HomeSearchViewController(parameters: ["searchKey" : searchKey ?? ""])
            self.pushVC(searchVC)
        }
        return customNavigationBar
    }()
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        isNavigationBarHidden = true
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setCustomNavigationBarSearchKeys()
        setCustomNavigationBarMessageNum()
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupCustomNavigationBar()
        addPageViewControllers(with: 1)
    }
    
    private func setupCustomNavigationBar() {
        self.view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(Constant.navigationHeight)
        }
    }
    
    /// 添加分页视图
    private func addPageViewControllers(with startIndex: Int = 0) {
        /// 首先移除之前添加的子页面和子组件
        self.children.forEach { child in
            child.removeFromParent()
        }
        self.view.subviews.forEach { view in
            if view is PageTitleView || view is PageContentView {
                view.removeFromSuperview()
            }
        }
        
        func setPagsStyle() -> PageStyle {
            let style = PageStyle()
            style.isShowBubble = true
            style.isBubbleScrollable = true
            style.isShowBottomLine = true
            style.isTitleScaleEnabled = true
            style.isShowRightSideMask = true
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
            
            return style
        }
        
        func setCategoryBtn(targetView: UIView) {
            let addBtn = UIButton()
            addBtn.setTitle("+", for: UIControl.State())
            addBtn.setTitleColor(.white, for: UIControl.State())
            addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .regular)
            addBtn.addTarget(self, action: #selector(addBtnAction), for: UIControl.Event.touchUpInside)
            targetView.addSubview(addBtn)
            addBtn.snp.makeConstraints { (make) in
                // 自动布局
                make.right.top.equalToSuperview()
                make.width.height.equalTo(36.0)
            }
        }
        
        var titles: [String] = []
        for index in 0..<categoryEntities.count {
            titles.append(categoryEntities[index].name)
            
            var subVC: HomSubViewController!
            switch categoryEntities[index].name {
            case "代码学习":
                subVC = HomSubViewController(parameters: ["type" : Category.code])
            case "组件封装":
                subVC = HomSubViewController(parameters: ["type" : Category.module])
            case "音视频":
                subVC = HomSubViewController(parameters: ["type" : Category.audioAndVideo])
            case "动画效果":
                subVC = HomSubViewController(parameters: ["type" : Category.animation])
            case "设计模式":
                subVC = HomSubViewController(parameters: ["type": Category.designMode])
            case "随笔":
                subVC = HomSubViewController(parameters: ["type" : Category.essay])
            default:
                subVC = HomSubViewController()
            }
            addChild(subVC)
        }

        pageViewManager = PageViewManager(style: setPagsStyle(), titles: titles, childViewControllers: children, startIndex: startIndex)
        if let titleView = pageViewManager?.titleView, let contentView = pageViewManager?.contentView {
            view.addSubview(titleView)
            view.addSubview(contentView)
            
            setCategoryBtn(targetView: titleView)
            
            titleView.snp.makeConstraints { (make) in
                make.left.width.equalToSuperview()
                make.top.equalTo(customNavigationBar.snp.bottom)
                make.height.equalTo(40.0)
            }
            
            contentView.snp.makeConstraints { (make) in
                make.top.equalTo(titleView.snp.bottom)
                make.left.width.bottom.equalToSuperview()
            }
        }
    }
}

//MARK: - Tabbar代理协议
extension HomeViewController: TabbarRefreshTargetProtocol {
    func refreshTarget() {
        printLog("首页 - 页面刷新")
        if let vc = self.children.safeObject(at: pageViewManager!.currentIndex) as? TabbarRefreshTargetProtocol{
            vc.refreshTarget()
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension HomeViewController {
    /// 添加导航条搜索框的热门搜索词
    private func setCustomNavigationBarSearchKeys() {
        customNavigationBar.setSearchKey(["热搜词1","热搜词2","热搜词3","热搜词4","热搜词5","热搜词6","热搜词7","热搜词8","热搜词9"])
    }
    
    /// 调整导航条消息组件数据
    private func setCustomNavigationBarMessageNum() {
        let count = CategoryManager.otherCategories().count
        customNavigationBar.setMessageNum("\(count)")
    }
    
    /// 跳转到分类选择页面
    @objc private func addBtnAction() {
        print("跳转到分类选择页面")
        let categoryVC = HomeCategoryViewController()
        categoryVC.updateHandle = { [weak self] (startIndex)in
            guard let self = self else {return}
            self.addPageViewControllers(with: startIndex)
            self.setCustomNavigationBarMessageNum()
        }
        categoryVC.switchoverHandle = { [weak self] (index) in
            guard let self = self else {return}
            self.pageViewManager?.select(atIndex: index)
        }
        pushVC(categoryVC)
    }
}

//MARK: - 数据请求
extension HomeViewController {
    
}





