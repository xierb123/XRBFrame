//
//  EssayExpressViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/4/25.
//

import UIKit

class EssayExpressViewController: BaseViewController {
    
    var current: Int = 0
    var target: Int = 0
    var time: Int = 0
    
    
    //MARK: - 懒加载
    lazy var currentNum: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.returnKeyType = .done
        textField.keyboardType = .default
        textField.placeholder = "请输入起始楼层"
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = false
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    lazy var targetNum: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.returnKeyType = .done
        textField.keyboardType = .default
        textField.placeholder = "请输入结束楼层"
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = false
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return textField
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("确认", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(getTime), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - UI布局
    private func setupView() {
        self.view.addSubview(currentNum)
        self.view.addSubview(targetNum)
        self.view.addSubview(confirmButton)
        
        currentNum.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
            make.width.equalTo(180)
            make.height.equalTo(30)
        }
        targetNum.snp.makeConstraints { make in
            make.centerX.width.height.equalTo(currentNum)
            make.top.equalTo(160)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(220)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
    }
}

//MARK: - 选择器事件(自定义方法)
extension EssayExpressViewController {
    
    @objc
    func getTime() {
        guard let currentStr = currentNum.text, let currentValue = currentStr.toInt() else {return}
        guard let targetStr = targetNum.text, let targetValue = targetStr.toInt() else {return}
        
        current = currentValue
        target = targetValue
        time = 0
        
        while( target > current) {
            if target % 2 == 0 && target / 2 > current{
                double()
            } else {
                minus()
            }
        }
        print("检测 - 次数: ", time)
        print("**********************")
    }
    
    func double() {
        target /= 2
        time += 1
        print("检测 - double: ", target)
    }
    func plus() {
        target += 1
        time += 1
        print("检测 - double: ", target)
    }
    func minus() {
        target -= 1
        time += 1
        print("检测 - minus: ", target)
    }
}
