//
//  ModuleVerificationCodeViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/30.
//
//  自定义验证码输入框

import UIKit

class ModuleVerificationCodeViewController: BaseViewController {
    
    //MARK: - 懒加载
    private lazy var codeInputView: VerificationCodeView = {
        let style = VerificationCodeViewStyle()
        
        let codeInputView = VerificationCodeView(style: style)
        codeInputView.codeHandle = { code in
            printLog(code)
        }
        return codeInputView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupCodeInputView()
    }
    
    private func setupCodeInputView() {
        self.view.addSubview(codeInputView)
        codeInputView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(100)
            make.height.equalTo(100)
        }
    }
}
