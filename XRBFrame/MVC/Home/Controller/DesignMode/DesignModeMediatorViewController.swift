//
//  DesignModeMediatorViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/11.
//
//  中介者模式
//  中介者模式是一种行为设计模式,能让你减少对象之间混乱无序的依赖关系
//  该模式会限制对象之间的直接交互,迫使他们通过一个中介者对象进行合作

import UIKit

class DesignModeMediatorViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

//MARK: - 生命周期事件接口
protocol AppLifecycleListener {
    func onAppWillEnterForeground()
    func onAppDidEnterBackground()
    func onAppDidFinishLaunching()
}

//MARK: - 接口默认实现
extension AppLifecycleListener {
    func onAppWillEnterForeground() {}
    func onAppDidEnterBackground() {}
    func onAppDidFinishLaunching() {}
}

//MARK: - 实现接口的类
class AppLifecycleListenerImp1: AppLifecycleListener {
    func onAppDidEnterBackground() {
        printLog("项目进入后台时,页面A做出操作")
    }
}

class AppLifecycleListenerImp2: AppLifecycleListener {
    func onAppDidEnterBackground() {
        printLog("项目进入后台时,页面B做出操作")
    }
}

//MARK: - 中介者主体
class AppLifecycleMediator: NSObject {
    private let listeners: [AppLifecycleListener]
    
    init(listeners: [AppLifecycleListener]) {
        self.listeners = listeners
        super.init()
        subscribe()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 订阅生命周期时间
    private func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAppWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAppDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAppDidFinishLaunching), name: UIApplication.didFinishLaunchingNotification, object: nil)
    }
    
    @objc private func onAppWillEnterForeground() {
        listeners.forEach { $0.onAppWillEnterForeground() }
    }
    
    @objc private func onAppDidEnterBackground() {
        listeners.forEach { $0.onAppDidEnterBackground() }
    }
    
    @objc private func onAppDidFinishLaunching() {
        listeners.forEach { $0.onAppDidFinishLaunching() }
    }
    
    //TODO: - 如需增加新的Listener,修改此处即可
    public static func makeDefaultMediator() -> AppLifecycleMediator {
        let listener1 = AppLifecycleListenerImp1()
        let listener2 = AppLifecycleListenerImp2()
        return AppLifecycleMediator(listeners: [listener1, listener2])
    }
}
