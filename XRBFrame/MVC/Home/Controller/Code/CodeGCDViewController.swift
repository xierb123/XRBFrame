//
//  CodeGCDViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/6/28.
//
//  多线程 - GCD

import UIKit

class CodeGCDViewController: BaseViewController {
    
    private var item: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
       
        item = Asyncs.delay(10) {
            print("我进来了")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        item?.cancel()
    }
    
}

//MARK: - 封装工具
public typealias TaskThread = () -> Void
/// 子线程 - 主线程封装工具
public struct Asyncs {
    
    public static func async(_ task: @escaping TaskThread) {
        _async(task)
    }
    
    public static func async(_ task: @escaping TaskThread,
                             _ mainTask: @escaping TaskThread) {
        _async(task, mainTask)
    }

    private static func _async(_ task: @escaping TaskThread,
                               _ mainTask: TaskThread? = nil) {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: .main, execute: main)
        }
    }
}

/// 延迟封装
extension Asyncs {
    @discardableResult
    public static func delay(_ second: Double, _ block: @escaping TaskThread) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: .now() + second,
                                      execute: item)
        return item
    }
}

/// 异步延迟
extension Asyncs {
    public static func asyncDelay(_ second: Double,
                                  _ task: @escaping TaskThread) -> DispatchWorkItem {
        return _asyncDelay(second, task)
    }
    
    public static func asyncDelay(_ second: Double,
                                  _ task: @escaping TaskThread,
                                  _ mainTask: @escaping TaskThread) -> DispatchWorkItem{
        return _asyncDelay(second, task, mainTask)
    }
    
    @discardableResult
    private static func _asyncDelay(_ second: Double,
                                    _ task: @escaping TaskThread,
                                    _ mainTask: TaskThread? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(deadline: .now() + second, execute: item)
        if let main = mainTask {
            item.notify(queue: .main, execute: main)
        }
        return item
    }
}
