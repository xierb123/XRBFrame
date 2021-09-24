//
//  LiveViewController.swift
//  BasicProgram
//
//  Created by 谢汝滨 on 2020/9/11.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class LiveViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = TabBarItemType.live.title
    
    }
}

//MARK: - Tabbar代理协议
extension LiveViewController: TabbarRefreshTargetProtocol {
    func refreshTarget() {
        printLog("直播 - 页面刷新")
    }
}
