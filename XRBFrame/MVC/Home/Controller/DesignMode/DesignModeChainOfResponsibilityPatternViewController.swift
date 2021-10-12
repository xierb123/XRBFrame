//
//  DesignModeChainOfResponsibilityPatternViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/9.
//
//  责任链模式
//  责任链模式是行为模式中的一种, 将请求沿着一条链传递,直到该链上的某个对象处理请求为止

import UIKit

class DesignModeChainOfResponsibilityPatternViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setSimulationData()
    }
    
    /// 模拟数据
    func setSimulationData() {
        var message = CodeScanEnum.none
        message.getTypeWithInfo("login")
        CodeScanManager.main(info: message)
    }
    
}
//MARK: - 责任链模式对应的选项枚举
enum CodeScanEnum {
    case none
    case login
    case push
    case quit
    
    mutating func getTypeWithInfo(_ info: Any?) {
        if let info = info as? String {
            switch info {
            case "login":
                self = .login
            case "push":
                self = .push
            case "quit":
                self = .quit
            default:
                self = .none
            }
        }
    }
}

//MARK: - 责任链模式的主体
protocol CodeScanHandler: AnyObject {
    /// 下一节点
    var nextHandler: CodeScanHandler? { get set }
    
    /// 设置下一节点
    @discardableResult func setNext(handler: CodeScanHandler) -> CodeScanHandler
    
    /// 这是返回值为bool类型, 用来标识请求是否被正确处理, 供客户端等使用
    func handle(info: Any?) -> Bool?
}

extension CodeScanHandler {
    /// 默认设置下一个节点的实现
    func setNext(handler: CodeScanHandler) -> CodeScanHandler {
        nextHandler = handler
        return handler
    }
    
    /// 节点处理的默认实现, 默认不实现, 直接交给下一个节点
    func handle(info: Any?) -> Bool? {
        return nextHandler?.handle(info: info)
    }
}


//MARK: - 责任链模式的具体处理者
class CodeScanLoginHandle: CodeScanHandler {
    var nextHandler: CodeScanHandler?
    
    func handle(info: Any?) -> Bool? {
        guard let info = info as? CodeScanEnum, info == .login else {
            return nextHandler?.handle(info: info)
        }
        printLog("这次是要登录的")
        return true
    }
}

class CodeScanPushHandle: CodeScanHandler {
    var nextHandler: CodeScanHandler?
    
    func handle(info: Any?) -> Bool? {
        guard let info = info as? CodeScanEnum, info == .push else {
            return nextHandler?.handle(info: info)
        }
        printLog("这次是要跳转的")
        return true
    }
}

class CodeScanQuitHandle: CodeScanHandler {
    var nextHandler: CodeScanHandler?
    
    func handle(info: Any?) -> Bool? {
        guard let info = info as? CodeScanEnum, info == .quit else {
            return nextHandler?.handle(info: info)
        }
        printLog("这次是要退出的")
        return true
    }
}

//MARK: - 客户端实现管理器
class CodeScanManager {
    static func main(info: Any?) {
        let startHandle = CodeScanLoginHandle()
        startHandle
            .setNext(handler: CodeScanPushHandle())
            .setNext(handler: CodeScanQuitHandle())
        
        guard let result = startHandle.handle(info: info), result else {
            //TODO: - 每个节点都没有成功处理, 执行相关逻辑
            printLog("没有找到对应的操作选项")
            return
        }
    }
}


