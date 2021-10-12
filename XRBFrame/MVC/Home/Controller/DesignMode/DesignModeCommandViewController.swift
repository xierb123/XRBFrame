//
//  DesignModeCommandViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/11.
//
//  命令模式
//  命令模式是一种行为设计模式, 可将请求包装为一个包含请求相关的所有信息的独立对象
//  该转换可以让你根据不同的请求将方法参数化, 延迟请求执行 或将其放入队列中, 且能实现可撤销操作

import UIKit

class DesignModeCommandViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AppDelegateCommandsBuilder()
            .setKeyWindow(UIApplication.shared.keyWindow!)
            .build()
            .forEach { $0.execute() }
    }
}

//MARK: - 命令接口
protocol AppDelegateDidFinishLaunchingCommand {
    func execute()
}

//MARK: - 初始化三方命令
struct InitializeThirdPartiesCommand: AppDelegateDidFinishLaunchingCommand {
    func execute() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            printLog("InitializeThirdPartiesCommand 触发")
        }
    }
}

//MARK: - 初始化RootViewController
struct InitialViewControllerCommand: AppDelegateDidFinishLaunchingCommand {
    var window: UIWindow!
    func execute() {
        printLog("InitialViewControllerCommand 触发")
    }
}

//MARK: - 命令构造器
final class AppDelegateCommandsBuilder {
    private var window: UIWindow!
    
    func setKeyWindow(_ window: UIWindow) -> AppDelegateCommandsBuilder {
        self.window = window
        return self
    }
    
    func build() -> [AppDelegateDidFinishLaunchingCommand] {
        return [
            InitializeThirdPartiesCommand(),
            InitialViewControllerCommand(window: window)
        ]
    }
}
