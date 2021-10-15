//
//  EssayRouterViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/14.
//
//  路由跳转页面
/*
    1.引入Router组件,依赖三方库URLNavigator
    2.需要在AppDelegate当中注册router
    3.创建RouterList.plist文件,声明需要跳转页面对应的路径键值对
    4.公共页面遵循RouterController协议,实现代理方法
    5.如果公共页面自定义初始化方法,需要在Router组件HKRouterMap文件的viewControllerFactory方法,调整初始化页面声明类型
 */

import UIKit

class EssayRouterViewController: BaseViewController {
    
    //MARK: - 懒加载
    private lazy var switchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Switch语法页面", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(switchBtnAction), for: UIControl.Event.touchUpInside)
        button.largeEdge = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        setupSwitchButton()
    }
    
    private func setupSwitchButton() {
        self.view.addSubview(switchButton)
        switchButton.snp.makeConstraints { (make) in
            // 自动布局
            make.centerX.equalToSuperview()
            make.top.equalTo(40)
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension EssayRouterViewController {
    
    @objc
    private func switchBtnAction() {
        HKRouter.open("\(HKRouterConfig.routerSchemesName)://routerDetailVC")
    }
    
}
