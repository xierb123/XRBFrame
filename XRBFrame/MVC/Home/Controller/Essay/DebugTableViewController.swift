//
//  DebugTableViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/11/15.
//
//  三段视图子页面

import UIKit
import FloatingPanel

class DebugTableViewController: BaseViewController {
    
    //MARK: - 全局变量
    var isDragAgain = false
    
    var fullHandle: (() -> ())? = nil
    var halfHandle: (() -> ())? = nil
    var bottomHandle: (() -> ())? = nil
    
    enum Command: Int, CaseIterable {
        case animateScroll
        case moveToFull
        case moveToHalf
        var text: String {
            switch self {
            case .animateScroll: return "Scroll in the middle"
            case .moveToFull: return "Move to Full"
            case.moveToHalf: return "Move to Half"
            }
        }

        static func replace(items: [String]) -> [String] {
            return items.enumerated().map { (index, text) -> String in
                if let action = Command(rawValue: index) {
                    return "\(index). \(action.text)"
                }
                return text
            }
        }

        func execute(for vc: DebugTableViewController, sourceView: UIView) {
            switch self {
            case .animateScroll:
                vc.animateScroll()
            case .moveToFull:
                vc.moveToFull()
            case .moveToHalf:
                vc.moveToHalf()
            }
        }
    }
    
    //MARK: - 懒加载
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = footerView
        
        return tableView
    }()
    
    lazy var footerView: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 80)
        button.setTitle("查看更多, 请前往商城", for: UIControl.State.normal)
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(goToStore), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var items: [String] = {
        let items = (0..<30).map { "Items \($0)" }
        return Command.replace(items: items)
    }()
    
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
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(50)
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension DebugTableViewController {
    
    @objc
    private func moveToFull() {
        (self.parent as! FloatingPanelController).move(to: .full, animated: true)
        fullHandle?()
    }

    @objc
    private func moveToHalf() {
        (self.parent as! FloatingPanelController).move(to: .half, animated: true)
        halfHandle?()
    }

    @objc
    private func close(sender: UIButton) {
        //  Remove FloatingPanel from a view
        (self.parent as! FloatingPanelController).removePanelFromParent(animated: true, completion: nil)
    }
    
    @objc
    private func animateScroll() {
        tableView.scrollToRow(at: IndexPath(row: lround(Double(items.count) / 2.0),
                                            section: 0),
                              at: .top, animated: true)
    }
    
    private func execute(command: Command, sourceView: UIView) {
        command.execute(for: self, sourceView: sourceView)
    }
    
    @objc
    private func goToStore() {
        Main.open(tabItem: .live, params: nil)
    }

    
}

//MARK: - 数据请求
extension DebugTableViewController {
    
}

//MARK: - TableView代理协议
extension DebugTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? UITableViewCell, indexPath.row < items.count else {
            return
        }
        cell.textLabel?.text = items[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < items.count else {
            return
        }
        // - 点击事件
        guard let action = Command(rawValue: indexPath.row) else { return }
        let cell = tableView.cellForRow(at: indexPath)
        execute(command: action, sourceView: cell ?? tableView)
        
    }
    
    func scroll (_ scrollView: UIScrollView) {
        let height = tableView.contentSize.height
        let contentYoffset = tableView.contentOffset.y
        
        printLog(height)
        printLog(contentYoffset)
    }
}





