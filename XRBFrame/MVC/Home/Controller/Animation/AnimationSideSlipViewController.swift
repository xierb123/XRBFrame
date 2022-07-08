//
//  AnimationSideSlipViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/5/7.
//
//  列表侧滑动画页面

import UIKit
import SwipeCellKit

class AnimationSideSlipViewController: BaseViewController {
    
    //MARK: - 全局变量
    var items = ["这个是条目1","这个是条目2","这个是条目3","这个是条目4",
                 "这个是条目5","这个是条目6","这个是条目7","这个是条目8"]
    
    //MARK: - 懒加载
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    
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
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupTableView()
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension AnimationSideSlipViewController {
    
}

//MARK: - 数据请求
extension AnimationSideSlipViewController {
    
}

//MARK: - TableView代理协议
extension AnimationSideSlipViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Toast.show("选中了第\(indexPath.row)条数据")
    }
    
    
    // 左滑操作
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //创建“解绑”事件按钮
        let unbind = UIContextualAction(style: .normal, title: "解绑") {
            (action, view, completionHandler) in
            //左滑归位
            Toast.show("点击了第\(indexPath.row)条数据的解绑按钮", position: .bottom)
            completionHandler(true)
        }
        unbind.backgroundColor = .lightGray
        
        //创建“授权”事件按钮
        let authorize = UIContextualAction(style: .normal, title: "授权") {
            (action, view, completionHandler) in
            Toast.show("点击了第\(indexPath.row)条数据的授权按钮", position: .bottom)
            completionHandler(true)
        }
        authorize.backgroundColor = .gray
        //返回所有的事件按钮 数组的第0个元素在最右边
        let configuration = UISwipeActionsConfiguration(actions: [authorize, unbind])
        return configuration
    }
    
    //头部滑动事件按钮（右滑按钮）
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //创建“更多”事件按钮
        let unread = UIContextualAction(style: .normal, title: "未读") {
            (action, view, completionHandler) in
            Toast.show("点击了第\(indexPath.row)条数据的未读按钮", position: .bottom)
            completionHandler(true)
        }
        unread.backgroundColor = UIColor(red: 52/255, green: 120/255, blue: 246/255,
                                         alpha: 1)
         
        //返回所有的事件按钮
        let configuration = UISwipeActionsConfiguration(actions: [unread])
        return configuration
    }
}

