//
//  CodeFunctionalProgrammingViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/7/1.
//
//  函数式编程

import UIKit

class CodeFunctionalProgrammingViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        calculator()
    }
}


//MARK: - 柯里化

/// 采用自定义运算符完成函数合成
infix operator >>>: AdditionPrecedence
func >>>(_ f1: @escaping (Int) -> Int,
         _ f2: @escaping (Int) -> Int) -> (Int) -> Int {
    {
        f2(f1($0))
    }
}

/// 运算符重载实现自动柯里化(二元)
prefix func ~<A, B, C>(_ fn: @escaping (A, B) -> C) -> (B) -> (A) -> C {
    {fn2 in {fn3 in fn(fn3, fn2) } }
}
/// 运算符重载实现自动柯里化(三元) - 参数倒序
//prefix func ~<A, B, C, D>(_ fn: @escaping (A, B, C) -> D) -> (C) -> (B) -> (A) -> D {
//    {fn2 in {fn3 in { fn4 in fn(fn4, fn3, fn2) } } }
//}
/// 运算符重载实现自动柯里化(三元) - 参数顺序
prefix func ~<A, B, C, D>(_ fn: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    {fn4 in {fn3 in { fn2 in fn(fn4, fn3, fn2) } } }
}

extension CodeFunctionalProgrammingViewController {
    /// 柯里化实现加 减 乘 除 取余 等运算
    func add(_ num: Int) -> (Int) -> Int { {$0 + num} }
    func sub(_ num: Int) -> (Int) -> Int { {$0 - num} }
    func multiply(_ num: Int) -> (Int) -> Int { {$0 * num} }
    func divide(_ num: Int) -> (Int) -> Int { {$0 / num} }
    func mod(_ num: Int) -> (Int) -> Int { {$0 % num} }
    
    /// 函数合成
    func composite(_ f1: @escaping (Int) -> Int,
                   _ f2: @escaping (Int) -> Int) -> (Int) -> Int {
        {
            f2(f1($0))
        }
    }
    
    /// 函数合成 泛型化
    func compositeWithGenericity<A,B,C>(_ fn1: @escaping (A) -> B,
                                        _ fn2: @escaping (B) -> C) -> (A) -> C {
        {
            fn2(fn1($0))
        }
    }
    
    /// 采用柯里化计算
    func calculator() {
        let num = 1
        
        let fn1 = add(3)
        let fn2 = multiply(5)
        let fn3 = sub(1)
        let fn4 = mod(10)
        let fn5 = divide(2)
        
        func add1(_ a: Int, _ b: Int) -> Int {
            return (a + b)
        }
        
        func add2(_ a: Int, _ b: Int, _ c: Int) -> Int {
            return a - b - c
        }
        
        //let result = fn5(fn4(fn3(fn2(fn1(num)))))
        let result = fn1 >>> fn2 >>> fn3 >>> fn4 >>> fn5
        
        print(addWithTriple(10)(20)(30))
        
        //print(result(num))
        
        print(add1(1, 4))
        print(currying(add1)(1)(4))
        print((~add1)(1)(4))
        print((~add2)(1)(4)(7))
        
    }
    
    /// 三元柯里化
    func addWithTriple(_ num: Int) -> ((Int) -> (Int) -> Int) {
        return { a in
            return { b in
                return (b + a + num)
            }
        }
    }
    
    /// 函数自动柯里化(二元)
    func currying<A,B,C>(_ fn: @escaping (A, B) -> C) -> ((B) -> (A) -> C){
        { fn2 in { fn3 in fn(fn3, fn2) } }
    }
}
