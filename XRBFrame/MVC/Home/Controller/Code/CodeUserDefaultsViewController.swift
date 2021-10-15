//
//  CodeUserDefaultsViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/8.
//

import UIKit

class CodeUserDefaultsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testUserDefaults()
    }
    
    private func testUserDefaults() {
        UserDefaultsEnum.age.save(int: 12)
        printLog(UserDefaultsEnum.age.string)
    }
}



