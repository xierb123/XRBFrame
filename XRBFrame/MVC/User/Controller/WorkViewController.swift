//
//  WorkViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/13.
//
import UIKit
import JXPagingView
import EmptyDataSet_Swift

class WorkViewController: BaseViewController {
    
    //MARK: - 全局变量
    private var tableView: UITableView!
    /// 数据源
    private var dataList: [UserListEntity]!
    /// 回调
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    //MARK: - 懒加载
    private lazy var menuView: UserMenuView = {
        let entity = InfoEntity(title: "作品", value: "12")
        var dataList = [InfoEntity]()
        for item in 0...3{
            dataList.append(entity)
        }
        let menuView = UserMenuView(infoArr: dataList)
        menuView.infoHandle = { tag in
            switch tag {
            case 0:
                print("跳转到作品")
            case 1:
                print("跳转到喜欢")
            case 2:
                print("跳转到草稿")
            case 3:
                print("跳转到丢弃")
            default:
                break
            }
        }
        return menuView
    }()
    
    
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        
        if let dataList = parameters?["dataList"] as? [UserListEntity]{
            self.dataList = dataList
        }
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
        
        setupTableView()
        setupMenuView()
    }
    // 创建菜单组件
    func setupMenuView() {
        menuView.height = 50
        tableView.tableHeaderView = menuView
    }
    
    // 创建tableView
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            // 自动布局
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-Constant.tabBarHeight)
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension WorkViewController {
    
}

//MARK: - 数据请求
extension WorkViewController {
    
}

//MARK: - TableView代理协议
extension WorkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath) as! UserListCell
        cell.show(entity: dataList[indexPath.row], index: indexPath.row)
        cell.actionHandle = { index in
            print("当前点击了第\(index)个按钮")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? UserListCell, indexPath.row < dataList.count else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < dataList.count else {
            return
        }
        // - 点击事件
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}

//MARK: - 代理协议,空数据保护
extension WorkViewController: EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return EmptyDataPage.search.title
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return EmptyDataPage.search.image
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return EmptyDataPage.search.verticalOffset
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return EmptyDataPage.search.spaceHeight
    }
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return EmptyDataPage.search.buttonImage
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        // 点击事件
    }
}
//MARK: - 代理协议,空数据保护
extension WorkViewController: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return dataList.isEmpty
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return EmptyDataPage.default.allowScroll
    }
}

//MARK: - 子页面列表协议
extension WorkViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }

    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }

    func listScrollView() -> UIScrollView {
        return tableView
    }
}



