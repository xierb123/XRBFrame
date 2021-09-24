//
//  SendViewController.swift
//  BasicProgram
//
//  Created by 谢汝滨 on 2020/9/11.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class SendViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "创作"
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissVC(completion: nil)
    }

}
