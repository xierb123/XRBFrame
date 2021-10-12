//
//  DesignModeDemoViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/12.
//

import UIKit
import sqlcipher

class DesignModeDemoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //setDataForChain()
        //setDataForStrategy()
        setDataForCommand()
        
    }
    
    func setDataForChain() {
        var objc = CodeScanEnum.none
        objc.getTypeWithInfo("Login")
        ChainManager.main(info: objc)
    }
    
    func setDataForStrategy() {
        var objc = CodeScanEnum.none
        objc.getTypeWithInfo("push")
        StrateryManager.main(info: objc)
    }
    
    func setDataForCommand() {
        CommandManager()
            .setInfo(typeA: "法外狂徒 - 张三", typeB: 18)
            .build()
            .forEach{ $0.showInfo()}
    }
}

// MARK: ******************************  责任链模式  ******************************
protocol ChainOfResponsibilityPatternProtocol: AnyObject {
    var nextHandler: ChainOfResponsibilityPatternProtocol? {get set}
    
    @discardableResult
    func setNext(handler: ChainOfResponsibilityPatternProtocol) -> ChainOfResponsibilityPatternProtocol
    
    func handle(info: Any?) -> Bool?
}
extension ChainOfResponsibilityPatternProtocol {
    func setNext(handler: ChainOfResponsibilityPatternProtocol) -> ChainOfResponsibilityPatternProtocol {
        self.nextHandler = handler
        return handler
    }
    
    func handle(info: Any?) -> Bool? {
        return nextHandler?.handle(info: info)
    }
}

class ChainOfResponsibilityPatternA: ChainOfResponsibilityPatternProtocol {
    var nextHandler: ChainOfResponsibilityPatternProtocol?
    
    func handle(info: Any?) -> Bool? {
        guard let info = info as? CodeScanEnum, info == .push else {
            return nextHandler?.handle(info: info)
        }
        printLog("捕获到推送")
        return true
    }
}
class ChainOfResponsibilityPatternB: ChainOfResponsibilityPatternProtocol {
    var nextHandler: ChainOfResponsibilityPatternProtocol?
    
    func handle(info: Any?) -> Bool? {
        guard let info = info as? CodeScanEnum, info == .quit else {
            return nextHandler?.handle(info: info)
        }
        printLog("捕获到退出")
        return true
    }
}
class ChainOfResponsibilityPatternC: ChainOfResponsibilityPatternProtocol {
    var nextHandler: ChainOfResponsibilityPatternProtocol?
    
    func handle(info: Any?) -> Bool? {
        guard let info = info as? CodeScanEnum, info == .login else {
            return nextHandler?.handle(info: info)
        }
        printLog("捕获到登录")
        return true
    }
}

class ChainManager {
    public static func main(info: Any?) {
        let startHandler = ChainOfResponsibilityPatternA()
        startHandler
            .setNext(handler: ChainOfResponsibilityPatternB())
            .setNext(handler: ChainOfResponsibilityPatternC())
        
        guard let result = startHandler.handle(info: info), result else {
            printLog("暂未找到匹配项")
            return
        }
    }
}

// MARK: ******************************  策略模式  ******************************
protocol StrategyProtocol {
    func deal(info: Any?)
}

struct StrategyA: StrategyProtocol{
    func deal(info: Any?) {
        printLog("咱们捕获到了登录哦 - \(info)")
    }
}
struct StrategyB: StrategyProtocol{
    func deal(info: Any?) {
        printLog("咱们捕获到了跳转哦 - \(info)")
    }
}
struct StrategyC: StrategyProtocol{
    func deal(info: Any?) {
        printLog("咱们捕获到了退出哦 - \(info)")
    }
}

struct StrategyContext {
    private var strategy: StrategyProtocol?
    
    init(type: Any?) {
        guard let type = type as? CodeScanEnum, type != .none else {
            printLog("这次一无所获呢")
            return
        }
        
        switch type {
        case .login:
            strategy = StrategyA()
        case .push:
            strategy = StrategyB()
        case .quit:
            strategy = StrategyC()
        case .none:
            break
        }
    }
    
    func deal(info: Any?) {
        strategy?.deal(info: info)
    }
}

class StrateryManager {
    public static func main(info: Any?) {
        StrategyContext(type: info).deal(info: info)
    }
}

// MARK: ******************************  命令模式  ******************************
protocol CommandProtocol {
    func showInfo()
}

struct CommandA: CommandProtocol {
    var typeA: String?
    func showInfo() {
        printLog("这是我第一次做坏事 - \(typeA)")
    }
}

struct CommandB: CommandProtocol {
    var typeB: Int?
    func showInfo() {
        printLog("这是我第二次做坏事 - \(typeB)")
    }
}

class CommandManager {
    var typeA: String?
    var typeB: Int?
    
    func setInfo(typeA: String?, typeB: Int?) -> CommandManager {
        self.typeA = typeA
        self.typeB = typeB
        return self
    }
    
    func build() -> [CommandProtocol] {
        return [
            CommandA(typeA: typeA),
            CommandB(typeB: typeB)
        ]
    }
}

// MARK: ******************************  中介者模式  ******************************

protocol MediatorProtocol {
    func onAppWillEnterForeground()
    func onAppDidEnterBackground()
    func onAppDidFinishLaunching()
}

extension MediatorProtocol {
    func onAppWillEnterForeground() {}
    func onAppDidEnterBackground() {}
    func onAppDidFinishLaunching() {}
}

class MediatorA: MediatorProtocol {
    func onAppWillEnterForeground() {
        printLog("页面A - 应用进入前台")
    }
}

class MediatorB: MediatorProtocol {
    func onAppDidEnterBackground() {
        printLog("页面B - 应用进入后台")
    }
}

class MediatorManager: NSObject {
    private let listeners: [MediatorProtocol]
    
    init(listeners: [MediatorProtocol]) {
        self.listeners = listeners
        super.init()
        subscribe()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAppWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAppDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAppDidFinishLaunching), name: UIApplication.didFinishLaunchingNotification, object: nil)
    }
    
    @objc
    func onAppWillEnterForeground() {
        listeners.forEach{$0.onAppWillEnterForeground()}
    }
    
    @objc
    func onAppDidEnterBackground() {
        listeners.forEach{$0.onAppDidEnterBackground()}
    }
    
    @objc
    func onAppDidFinishLaunching() {
        listeners.forEach{$0.onAppDidFinishLaunching()}
    }
    
    static func makeDefaultMediator() -> MediatorManager {
        let listener1 = MediatorA()
        let listener2 = MediatorB()
        return MediatorManager(listeners: [listener1, listener2])
    }
}
