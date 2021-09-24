//
//  CodeARCViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/30.
//
//  内存分配

import UIKit

class CodeARCViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showARC()
    }
    
    private func showARC() {
        var bob: PersonA? = PersonA(name: "张三")
        printLog(bob!.description)
        //bob = nil
        
        var hat: Asset? = Asset(name: "帽子", value: 14.9)
        var tv: Asset? = Asset(name: "电视", value: 100.0)
        printLog(hat!.description)
        
        bob?.addAsset(hat!)
        bob?.addAsset(tv!)
        bob?.removeAsset(hat!)
        
        hat = nil
    }
   
}

class PersonA: CustomStringConvertible {
    var name: String
    let account = Accountant()
    var assets: [Asset]?
    var description: String {
        return "Person - \(name)"
    }
    
    func addAsset(_ asset: Asset) {
        account.gained(asset) {
            asset.owner = self
            assets?.append(asset)
        }
    }
    
    func removeAsset(_ asset: Asset) {
        account.remove(asset) {
            asset.owner = nil
            self.assets?.removeAll(where: { target in
                return asset.name == target.name
            })
        }
    }
    
    init(name: String) {
        self.name = name
        account.worthChangeHandle = { [weak self] worth in
            self?.showWorth(with: worth)
        }
    }
    
    func showWorth(with worth: Double) {
        printLog("现在的家当是\(worth)元")
    }
    
    deinit {
        printLog("Person - \(name)被销毁")
    }
}

class Asset: CustomStringConvertible {
    let name: String
    let value: Double
    weak var owner: PersonA?
    
    var description: String {
        if let actualOwner = owner {
            return ("Asset\(name), worth: \(value), has owner \(actualOwner.name)")
        } else {
            return ("Asset\(name), worth: \(value), has no owner")
        }
    }
    
    init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
    
    deinit {
        printLog("Asset - \(name)被销毁")
    }
        
}

class Accountant {
    var worthChangeHandle: ((Double) -> ())? = nil
    var worth: Double = 0.0 {
        didSet {
            worthChangeHandle?(worth)
        }
    }
    
    /// 非逃逸闭包 - 一函数参数形式生命的闭包默认是非逃逸的
    func gained(_ asset: Asset, completion: () -> ()) {
        worth += asset.value
        completion()
    }
    
    
    
    /// 添加@escaping 修饰,可将闭包设为逃逸闭包
    func remove(_ asset: Asset, completion: @escaping () -> ()) {
        worth -= asset.value
        completion()
    }
}
