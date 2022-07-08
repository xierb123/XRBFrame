//
//  CodeMeatdataViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/3/8.
//

import UIKit

protocol AnimalDelegate {
    init()
    var desc: String{ get }
}
class DogClass: AnimalDelegate {
    var desc: String {
        return "这是一只🐶"
    }
    required init() {}
    
}
class CatClass: AnimalDelegate {
    var desc: String {
        return "这是一只🐱"
    }
    required init() {}
    
}
class PigClass: AnimalDelegate {
    var desc: String {
        return "这是一只猪"
    }
    required init() {}
    
}

class CodeMeatdataViewController : BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let array = create([DogClass.self, CatClass.self, PigClass.self])
        for item in array {
            
            print(item.desc)
        }
        print(array)
        
    }
    
    // 可以通过元类型创建对象
    func create(_ clas: [AnimalDelegate.Type]) -> [AnimalDelegate] {
        var array = [AnimalDelegate]()
        for cla in clas {
            array.append(cla.init())
        }
        return array
    }
}
