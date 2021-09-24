//
//  ModuleMutableTableViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/8.
//
//  多样化列表页面

import UIKit
import EmptyDataSet_Swift

class ModuleMutableTableViewController: BaseViewController {
    
    //MARK: - 全局变量
    private var tableView: UITableView!
    private var dataList: [[UserListEntity]] = []
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setSimulationData()
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
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MutableTableCell.self, forCellReuseIdentifier: MutableTableCell.identifier)
        tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            // 自动布局
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension ModuleMutableTableViewController {
    
}

//MARK: - 数据请求
extension ModuleMutableTableViewController {
    
    // 设置模拟数据
    private func setSimulationData() {
        let entity = UserListEntity(title: "追龙", subTitle: "《追龙》是由银都机构有限公司出品的动作犯罪片，由王晶、关智耀执导，甄子丹领衔主演、刘德华特别演出、郑则仕、姜皓文、刘浩龙、胡然、徐冬冬等联合主演。该片于2017年9月30日在中国内地上映。该片讲述了能打敢拼的伍世豪从汕头偷渡来到香港为了长久生存之道，他与心思缜密的探长雷洛联手制霸香港的故事。")
        let times = [4,9,8,6,5]
        for item in times{
            var itemEntities = [UserListEntity]()
            for _ in 0...item {
                itemEntities.append(entity)
            }
            dataList.append(itemEntities)
        }
        tableView.reloadData()
    }
}

//MARK: - TableView代理协议
extension ModuleMutableTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section % 2 == 0 ? dataList[section].count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath) as! UserListCell
            cell.show(entity: dataList[indexPath.section][indexPath.row], index:   indexPath.row)
            cell.actionHandle = { [weak self] index in
                printLog("表格按钮 - \(self?.dataList[indexPath.section][indexPath.row].title ?? "") - \(indexPath.row)")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MutableTableCell.identifier, for: indexPath) as! MutableTableCell
            cell.collectionCellHandle = {(index, entity) in
                printLog("子表格cell -\(entity.title) - \(index)")
            }
            cell.show(entities: dataList[indexPath.section])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section % 2 == 1 {
            return 200
        } else {
            return 180
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackground
        
        let label = UILabel()
        label.textAlignment = .left
        label.text = "栏目 - \(section)"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        headerView.addSubview(label)
        label.snp.makeConstraints { (make) in
            // 自动布局
            make.center.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // - 点击事件
        guard indexPath.section % 2 == 0 else{ // 正常的cell
            return
        }
        printLog("正常cell - \(dataList[indexPath.section][indexPath.row].title) - \(indexPath.row)")
    }
}



//MARK: - 代理协议,空数据保护
extension ModuleMutableTableViewController: EmptyDataSetSource {
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
extension ModuleMutableTableViewController: EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return dataList.isEmpty
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return EmptyDataPage.default.allowScroll
    }
}

//MARK: - <#自定义#>代理协议
//extension <#ViewController#>: <#delegate#> {
//
//}



