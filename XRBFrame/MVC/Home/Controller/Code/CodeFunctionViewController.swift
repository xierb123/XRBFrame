//
//  CodeFunctionViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/26.
//

import UIKit

class CodeFunctionViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showFunction()
        showFunction2(with: "张三")
        showFunction3(with: "张三","李四","王五","赵六")
        showFunction4()
        
        var name = "张三"
        showFunction5(with: &name)
        
        printLog(showFunction6(with: "张三"))
        showFunction7(with: "张三")
        
        let entity = showFunction8(with: "张三")
        printLog("\(entity.name)是个名字只有\(entity.length)个字的小孩")
        
        printLog(showFunction9(with: "张老三") ?? "暂无姓名")
        showFunction10(with: "张三")
    }
    
    /// 一个基本的函数,没有参数也没有返回值
    private func showFunction() {
        printLog("普通参数")
    }
    
    /// 含参的函数
    private func showFunction2(with name: String) {
        printLog(name)
    }
    
    /// 变长参数
    private func showFunction3(with names: String...){
        printLog(names)
    }
    
    /// 默认函数参数值
    private func showFunction4(with name: String = "张三"){
        printLog(name)
    }
    
    /// in-out参数,可以修改外部传入的参数值,调用时不能直接传值,需要传入引用地址
    private func showFunction5(with name: inout String) {
        name = "李四"
        printLog(name)
    }
    
    /// 返回值
    private func showFunction6(with name: String) -> String {
        return name + "是个小可爱"
    }
    
    /// 嵌套函数
    private func showFunction7(with name: String) {
        func getName(_ name: String) -> String {
            return name + "是个小可爱"
        }
        printLog(getName(name))
    }
    
    /// 多个返回值
    private func showFunction8(with name: String) -> (name: String, length: Int) {
        return(name, name.length)
    }
    
    /// 可空返回值
    private func showFunction9(with name: String) -> String? {
        return name == "张三" ? name : nil
    }
    
    /// 提前退出函数
    private func showFunction10(with name: String) {
        guard name == "张三" else { // 不符合条件(name == "张三")的会直接退出
            return
        }
        printLog(name) // 只有符合条件才会继续往下走
    }
}
