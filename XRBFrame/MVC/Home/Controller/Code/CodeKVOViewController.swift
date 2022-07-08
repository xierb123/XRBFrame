//
//  CodeKVOViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/6/28.
//
//  KVO

import UIKit

class CodeKVOViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setKVO()
        setKVOForBlcok()
    }
}

//MARK: - KVO设置 - 方式1
class Observer: NSObject {
    override  func observeValue(forKeyPath keyPath: String?,
                                of object: Any?,
                                change: [NSKeyValueChangeKey : Any]?,
                                context: UnsafeMutableRawPointer?) {
        print("get new value: ", change?[.newKey] as Any)
    }
}

class PersonForKVO: NSObject {
    @objc
    dynamic var age: Int = 0
    
    var observer: Observer = Observer()
    
    override init() {
        super.init()
        addObserver(observer, forKeyPath: "age", options: .new, context: nil)
    }
    
    deinit {
        removeObserver(observer, forKeyPath: "age")
    }
}

extension CodeKVOViewController {
    func setKVO() {
        let person = PersonForKVO()
        person.age = 10
        person.setValue(12, forKey: "age")
    }
}

//MARK: - KVO设置 - 方式2
class PersonForBlock: NSObject {
    @objc dynamic var age: Int = 0
    var observation: NSKeyValueObservation?
    override init() {
        super.init()
        observation = observe(\PersonForBlock.age, options: .new, changeHandler: { person, change in
            print("重新赋值后的age: ", change.newValue as Any)
        })
    }
}
extension CodeKVOViewController {
    func setKVOForBlcok() {
        let person = PersonForBlock()
        person.age = 10
        person.setValue(12, forKey: "age")
    }
}
