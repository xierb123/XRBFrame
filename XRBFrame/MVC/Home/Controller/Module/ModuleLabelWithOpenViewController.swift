//
//  ModuleLabelWithOpenViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/3/18.
//
//  <#名称#>页面

import UIKit

class ModuleLabelWithOpenViewController: BaseViewController {
    
    //MARK: - 全局变量
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit方法
    required init(parameters: [String : Any]? = nil) {
        super.init(parameters: parameters)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - UI布局
    private func setupView() {
        let customLabel = CustomLabelWithOpen()
        self.view.addSubview(customLabel)
        customLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(200)
        }

        customLabel.setValue(with: "abcdabcdab最多显示2行且2行表示不完的情况下结尾以省略号表示不完的情况下结尾以省略号表示不完的情况下结尾以省略号表示")
    }
}

//MARK: - 选择器事件(自定义方法)
extension ModuleLabelWithOpenViewController {
    
}


