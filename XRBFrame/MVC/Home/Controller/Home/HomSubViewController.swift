//
//  HomSubViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/18.
//
//  首页分类子页面

import UIKit
import EmptyDataSet_Swift

enum Category {
    case code
    case module
    case audioAndVideo
    case animation
    case designMode
    case essay
}

class HomSubViewController: BaseViewController {
    
    //MARK: - 全局变量
    private var type: Category?
    private var tableView: UITableView!
    /// 是否展示cell动画
    private var showAnimation: Bool = false
    
    //MARK: - 懒加载
    private lazy var dataList: [String]  = {
        switch type {
        case .code:
            return HomeSubListPushManager.code
        case .module:
            return HomeSubListPushManager.module
        case .audioAndVideo:
            return HomeSubListPushManager.audioAndVideo
        case .animation:
            return HomeSubListPushManager.animation
        case .designMode:
            return HomeSubListPushManager.designMode
        case .essay:
            return HomeSubListPushManager.essay
        case .none:
            return []
        }
    }()
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        
        if let type = parameters?["type"] as? Category {
            self.type = type
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
            self?.showAnimation = true
        }
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Constant.margin, bottom: Constant.separatorHeight, right: Constant.margin)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SubViewCell.self, forCellReuseIdentifier: SubViewCell.identifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            // 自动布局
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-Constant.tabBarHeight)
        }
    }
}



//MARK: - 选择器事件(自定义方法)
extension HomSubViewController {
    
    
}

//MARK: - Tabbar代理协议
extension HomSubViewController: TabbarRefreshTargetProtocol {
    func refreshTarget() {
        printLog(self.type)
    }
}

//MARK: - TableView代理协议
extension HomSubViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubViewCell.identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SubViewCell, indexPath.row < dataList.count else {
            return
        }
        cell.show(title: dataList[indexPath.row], index: indexPath.row)
        if showAnimation {
            cell.cellAnimation()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < dataList.count else {
            return
        }
        // - 点击事件
        HomeSubListPushManager.pushVC(with: self, type: type ?? .code, indexPath: indexPath)
    }
}



//MARK: - 代理协议,空数据保护
extension HomSubViewController: EmptyDataSetSource {
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
extension HomSubViewController: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return dataList.isEmpty
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return EmptyDataPage.default.allowScroll
    }
}



