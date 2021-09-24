//
//  CodeGenericsViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/30.
//
//  泛型

import UIKit

class CodeGenericsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showGenerics()
        showGenerics2()
    }
    
    
    private func showGenerics() {
        let arr1 = [1,2,3,4,5,6,7,8,9]
        
        let arr2 = MyMap(arr1) { item in
            return item + 10
        }
        printLog(arr2)
        
        let arr3 = MyFilter(arr1) { item in
            return item > 5
        }
        printLog(arr3)
        
        let arr4 = findAll(["a","C","M","张三","李四","6"], "C")
        printLog(arr4)
    }
    
    private func showGenerics2() {
        printLog(checkEquable(10, 22.0))
    }
}

/// 泛型数据结构
struct Stack<T> {
    var items = [T]()
    
    mutating func push(_ newItem: T) {
        items.append(newItem)
    }
    
    mutating func pop() -> T? {
        guard !items.isEmpty else {
            return nil
        }
        return items.removeLast()
    }
}

/// 泛型函数和方法
extension CodeGenericsViewController {
    
    func MyMap<T, U>(_ items: [T], _ f: ((T) -> U)) -> [U] {
        var result = [U]()
        for item in items {
            result.append(f(item))
        }
        return result
    }
    
    func MyFilter<T>(_ items: [T], _ f:(T) -> Bool) -> [T] {
        var result = [T]()
        for item in items{
            if f(item) {
                result.append(item)
            }
        }
        return result
    }
    
    func findAll<T: Equatable>(_ items: [T], _ target: T) -> [Int]? {
        var result = [Int]()
        for (index, item) in items.enumerated() {
            if item == target {
                result.append(index)
            }
        }
        return result.isEmpty ? nil :result
    }
}

/// 类型约束
extension CodeGenericsViewController {
    func checkEquable<T: Equatable>(_ a: T, _ b: T) -> Bool {
        return a == b
    }
}
