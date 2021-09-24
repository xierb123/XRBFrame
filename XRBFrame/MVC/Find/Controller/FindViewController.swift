//
//  FindViewController.swift
//  BasicProgram
//
//  Created by 谢汝滨 on 2020/9/11.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class FindViewController: BaseViewController {
    
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = TabBarItemType.find.title
    }

}

//MARK: - Tabbar代理协议
extension FindViewController: TabbarRefreshTargetProtocol {
    func refreshTarget() {
        printLog("发现 - 页面刷新")
    }
}
