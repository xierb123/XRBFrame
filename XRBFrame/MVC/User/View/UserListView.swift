//
//  UserListView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/12.
//

import UIKit
import EmptyDataSet_Swift
import JXPagingView

class UserListView: UIView {
    
    //MARK: - 代理协议
    //weak var delegate: <#Delegate#>?
    
    //MARK: - 回调方法
    //var <#handle#>: (() -> Void)? = nil
    
    //MARK: - 全局变量
    private var tableView: UITableView!
    /// 数据源
    private var dataList: [UserListEntity]!
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    //MARK: - 懒加载
    
    
    //MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupTableView()
    }
    
    // 创建tableView
    private func setupTableView() {
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
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            // 自动布局
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension UserListView {
    /// 更新数据源
    func updateDataSource(_ dataList: [UserListEntity]) {
        self.dataList = dataList
        tableView.reloadData()
    }
}

//MARK: - TableView代理协议
extension UserListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? UserListCell, indexPath.row < dataList.count else {
            return
        }
        cell.show(entity: dataList[indexPath.row], index: indexPath.row)
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
extension UserListView: EmptyDataSetSource {
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
extension UserListView: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return dataList.isEmpty
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return EmptyDataPage.default.allowScroll
    }
}

extension UserListView: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return self
    }
    
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.tableView
    }
}

