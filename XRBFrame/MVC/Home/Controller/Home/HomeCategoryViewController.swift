//
//  HomeCategoryViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/19.
//
//  首页分类管理页面页面

import UIKit
import EmptyDataSet_Swift

class HomeCategoryViewController: BaseViewController {
    
    //MARK: - 回调方法
    var updateHandle: ((Int) -> ())? = nil
    var switchoverHandle: ((Int) -> ())? = nil
    
    //MARK: - 全局变量
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    /// 是否点击返回按钮返回
    private var isClickToBack: Bool = false
    /// 页面创建时的类别数据
    private var oldSelectedCategories = CategoryManager.selectedCategories()
    
    //MARK: - 懒加载
    private lazy var customNavigationBar: CustomNavigationBar = {
        let navigationBar = CustomNavigationBar()
        navigationBar.title = "类目管理"
        navigationBar.delegate = self
        return navigationBar
    }()
    private lazy var categoryView: CategoryView = {
        /// 类别数据
        var selectedCategories: [CategoryEntity] = {
            return CategoryManager.selectedCategories()
        }()
        var otherCategories: [CategoryEntity] = {
            return CategoryManager.otherCategories()
        }()
        let categoryView = CategoryView(selectedCategories: selectedCategories, otherCategories: otherCategories)
        categoryView.switchoverCallback = { [weak self] (index) in
            guard let self = self else {return}
            self.isClickToBack = true
            self.updateInfoJudge(index, isTagAction: true)
            self.clickBackBtn()
        }
        return categoryView
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
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupCustomNavigationBar()
        setupCategoryView()
    }
    
    private func setupCustomNavigationBar() {
        self.view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Constant.navigationHeight)
        }
    }
    private func setupCategoryView() {
        self.view.addSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(Constant.navigationHeight)
        }
    }
}

//MARK: - 侧滑返回
extension HomeCategoryViewController {
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if let _ = parent {
            print("准备跳转进到当前页面")
        } else {
            if !isClickToBack {
                print("侧滑返回,需要手动调用")
                updateInfoJudge()
            }
            print("准备返回父级页面")
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if let _ = parent {
            print("已经跳转进到当前页面")
        } else {
            print("已经返回父级页面")
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension HomeCategoryViewController {
    
}

//MARK: - 数据请求
extension HomeCategoryViewController {
    
}

extension HomeCategoryViewController: CustomNavigationBarDelegate {
    func goback(_ navigationBar: CustomNavigationBar) {
        updateInfoJudge()
        isClickToBack = true
        clickBackBtn()
    }
    
    /// 判断是否需要更新信息
    func updateInfoJudge(_ startIndex: Int = 1, isTagAction: Bool = false) {
        categoryView.updateCategories { [weak self] in
            guard let self = self else {return}
            let newSelectedCategories = CategoryManager.selectedCategories()
            if self.oldSelectedCategories == newSelectedCategories {
                print("分类没有变化")
                if isTagAction {
                    self.switchoverHandle?(startIndex)
                }
                return
            }
            self.updateHandle?(startIndex)
        }
    }
}
