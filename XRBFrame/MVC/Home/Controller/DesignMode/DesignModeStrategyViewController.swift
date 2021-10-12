//
//  DesignModeStrategyViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/9.
//
//  策略模式
//  策略模式是行为模式中的一种, 自定义了一系列算法, 并将每一个算法单独封装起来, 而且使他们可以相互替换
//  策略模式让算法独立于使用它的客户而独立变化


import UIKit

class DesignModeStrategyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setSimulationData()
    }
    
    /// 模拟数据
    func setSimulationData() {
        var message = CodeScanEnum.none
        message.getTypeWithInfo("quit")
        CodeScanStrategyManager.main(info: message)
    }
}

//MARK: - 策略模式的主体
protocol CodeScanStrategy {
    /// 处理抽象方法
    func deal(info: Any?)
}

//MARK: - 策略的具体实现, 每个struct都是一个单独的策略
struct CodeScanLoginStrategy: CodeScanStrategy {
    func deal(info: Any?) {
        //TODO: - 登录将要进行的操作
        printLog("这里是要登录的哦")
    }
}
struct CodeScanPushStrategy: CodeScanStrategy {
    func deal(info: Any?) {
        //TODO: - 跳转将要进行的操作
        printLog("这里是要跳转的哦")
    }
}
struct CodeScanQuitStrategy: CodeScanStrategy {
    func deal(info: Any?) {
        //TODO: - 退出将要进行的操作
        printLog("这里是要退出的哦")
    }
}

//MARK: - 用来操作策略的上下文环境
class CodeScanContext {
    private var strategy: CodeScanStrategy?
    
    init(type: CodeScanEnum) {
        switch type {
        case .push:
            self.strategy = CodeScanPushStrategy()
        case .login:
            self.strategy = CodeScanLoginStrategy()
        case .quit:
            self.strategy = CodeScanQuitStrategy()
        case .none:
            printLog("当前无事可做呢")
            break
        }
    }
    
    public func deal(info: Any?) {
        strategy?.deal(info: info)
    }
}

//MARK: - 客户端实现管理器
class CodeScanStrategyManager {
    public static func main(info: Any?) {
        if let type = info as? CodeScanEnum {
            CodeScanContext(type: type).deal(info: info)
        }
    }
}



