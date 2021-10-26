//
//  EssayRouterDetailViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/14.
//

import UIKit

class EssayRouterDetailViewController: BaseWebViewController {
    private var titleString: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = titleString
        
        setupDataForChainMode()
        loadURL()
    }
    
    
    override func initRouterParams(params: Dictionary<String, String>) {
        titleString = params["titleString"]
        
    }
    
    private func setupDataForChainMode() {
        var object = CodeScanEnum.none
        object.getTypeWithInfo("quit")
        ChainModeManager.main(info: object)
    }
    
    private func loadURL() {
        let urlString = "https://ask.haikanaichong.com/app/activity/fdb50d1ab26042efaf6a011c1c30752a"
        if let url = URL(string: urlString) {
            let cacheRequest = URLRequest.init(url: url)
            webView.load(cacheRequest)
        }
    }
}

protocol  ChainModeProtocol: AnyObject {
    var nextHandler: ChainModeProtocol? {get set}
    
    func setNext(handler: ChainModeProtocol) -> ChainModeProtocol
    
    func deal(info: Any?) -> Bool?
    
    func handle(info: CodeScanEnum) -> Bool?
}

extension ChainModeProtocol {
    func setNext(handler: ChainModeProtocol) -> ChainModeProtocol {
        self.nextHandler = handler
        return handler
    }
    
    func deal(info: Any?) -> Bool? {
        guard let info = info as? CodeScanEnum, info != .none else {
            printLog("没找到任何信息")
            return false
        }
        return handle(info: info)
    }
}

class ChainModeA: ChainModeProtocol {
    var nextHandler: ChainModeProtocol?
    func handle(info: CodeScanEnum) -> Bool? {
        guard info == .push else {
            return nextHandler?.deal(info: info)
        }
        printLog("捕获到了跳转信号")
        return true
    }
}

class ChainModeB: ChainModeProtocol {
    var nextHandler: ChainModeProtocol?
    func handle(info: CodeScanEnum) -> Bool? {
        guard info == .login else {
            return nextHandler?.deal(info: info)
        }
        printLog("捕获到了登录信号")
        return true
    }
}

class ChainModeC: ChainModeProtocol {
    var nextHandler: ChainModeProtocol?
    func handle(info: CodeScanEnum) -> Bool? {
        guard info == .quit else {
            return nextHandler?.deal(info: info)
        }
        printLog("捕获到了退出信号")
        return true
    }
}

class ChainModeManager {
    static func main(info: Any?) {
        let startHandler = ChainModeA()
        startHandler
            .setNext(handler: ChainModeB())
            .setNext(handler: ChainModeC())
        startHandler.deal(info: info)
    }
}
