//
//  EssayFloatingPanelViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/11/15.
//
//  三段式滚动图页面

import UIKit
import FloatingPanel

class EssayFloatingPanelViewController: BaseViewController, FloatingPanelControllerDelegate {
    
    var fpc: FloatingPanelController!
    
    
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
        
        // Initialize a `FloatingPanelController` object.
        fpc = FloatingPanelController()
        
        // Assign self as the delegate of the controller.
        fpc.delegate = self // Optional
        
        fpc.layout = MyFloatingPanelLayout()
        
        fpc.surfaceView.grabberHandle.isHidden = true
        
        // Set a content view controller.
        let contentVC = DebugTableViewController()
        fpc.set(contentViewController: contentVC)
        
        // Track a scroll view(or the siblings) in the content view controller.
        fpc.track(scrollView: contentVC.tableView)
        
        // Add and show the views managed by the `FloatingPanelController` object to self.view.
        fpc.addPanel(toParent: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        printLog("应该滑动到底部")
        fpc.move(to: .tip, animated: true, completion: nil)
    }
    
    //MARK: - UI布局
    private func setupView() {
        
    }
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .half:
            printLog("滑动到中间展示")
        case .full:
            printLog("滑动到顶部展示")
        case .tip:
            printLog("滑动到底部展示")
        case .hidden:
            printLog("隐藏")
        default:
            break
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension EssayFloatingPanelViewController {
    
    
}

//MARK: - 数据请求
extension EssayFloatingPanelViewController {
    
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.7, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 144.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}





