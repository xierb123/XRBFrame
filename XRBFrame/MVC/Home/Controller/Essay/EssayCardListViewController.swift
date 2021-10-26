//
//  EssayCardListViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/22.
//
//  卡片子列表页面

import UIKit
import JXPagingView
import EmptyDataSet_Swift

class EssayCardListViewController: BaseViewController {
    
    //MARK: - 全局变量
    private var tableView: UITableView!
    private var isTop = true
    private var showSection: Int = 0
    
    /// 回调
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    private var simulationData: [Any]!
    
    //MARK: - 懒加载
   
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        
        if let simulationData = parameters?["simulationData"] as? [Any]{
            self.simulationData = simulationData
            self.showSection = simulationData.count - 1
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
    }
    
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
        tableView.estimatedRowHeight = 0
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(EssayCardListCell.self, forCellReuseIdentifier: EssayCardListCell.identifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            // 自动布局
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension EssayCardListViewController {
   
}

//MARK: - 数据请求
extension EssayCardListViewController {
    
}

//MARK: - TableView代理协议
extension EssayCardListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return simulationData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = (simulationData[section] as! [String : Any])["list"] as! Array<Int>
        return section == showSection ? data.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EssayCardListCell.identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EssayCardListSectionHeaderView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 50))
        let title = (simulationData[section] as! [String : Any])["title"] as! String
        headerView.setupTitle(title, index: section)
        headerView.setupColor(bgColor: .darkGray, contentColor: .red)
        headerView.headerHandle = { [weak self] index in
            guard let self = self else {return}
            self.showSection = index
            self.tableView.reloadData()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let data = (simulationData[indexPath.section] as! [String : Any])["list"] as! Array<Int>
        guard let cell = cell as? EssayCardListCell, indexPath.row < data.count else {
            return
        }
        cell.show(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = (simulationData[indexPath.section] as! [String : Any])["list"] as! Array<Int>
        guard indexPath.row < data.count else {
            return
        }
        // - 点击事件
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}


//MARK: - 代理协议,空数据保护
extension EssayCardListViewController: EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return EmptyDataPage.search.title
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
extension EssayCardListViewController: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return simulationData.isEmpty
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return EmptyDataPage.default.allowScroll
    }
}

//MARK: - 子页面列表协议
extension EssayCardListViewController: JXPagingViewListViewDelegate {
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






