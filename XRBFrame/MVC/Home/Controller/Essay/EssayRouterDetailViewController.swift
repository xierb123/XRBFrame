//
//  EssayRouterDetailViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/14.
//

import UIKit

class EssayRouterDetailViewController: BaseViewController {
    private var titleString: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = titleString
    }
    

    override func initRouterParams(params: Dictionary<String, String>) {
        titleString = params["titleString"]
        
    }
}
