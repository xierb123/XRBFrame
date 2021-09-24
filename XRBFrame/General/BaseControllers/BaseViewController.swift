//
//  BaseViewController.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import SnapKit

protocol NavigateBackProtocol {
    func navigateToBack()
}

class BaseViewController: UIViewController {
    var parameters: [String: Any]?
    var isNavigationBarHidden: Bool = false

    private(set) var isFirstAppearance: Bool = true
    
    private lazy var backBtn: UIButton = {
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 18))
        backBtn.setImage(UIImage(named: "ic_navigation_back_black"), for: .normal)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 16)
        backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        return backBtn
    }()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    required init(parameters: [String: Any]? = nil) {
        self.parameters = parameters
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        Toast.show( "deinit: \(type(of: self))页面被注销")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if parent == nil || parent is UINavigationController {
            navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstOfNavigation {
            // 禁用侧滑手势（修复iOS12以后因在rootViewController上侧滑返回造成的卡死界面bug）
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if parent == nil || parent is UINavigationController {
            if let topVC = navigationController?.topViewController as? BaseViewController {
                if !topVC.isNavigationBarHidden {
                    navigationController?.setNavigationBarHidden(false, animated: true)
                }
            }
        }
        
        if isFirstOfNavigation {
            // 启用侧滑手势（修复iOS12以后因在rootViewController上侧滑返回造成的卡死界面bug）
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isFirstAppearance = false
    }
    
    private func setupView() {
        view.backgroundColor = Color.background
        
        if !isNavigationBarHidden {
            let viewControllersCount = navigationController?.viewControllers.count ?? 0
            if viewControllersCount > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            }
        }
    }
}

extension BaseViewController {
    @objc func clickBackBtn() {
        if let executor = self as? NavigateBackProtocol {
            executor.navigateToBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
