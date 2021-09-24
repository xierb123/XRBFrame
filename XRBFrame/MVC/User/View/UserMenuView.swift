//
//  UserMenuView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/13.
//

import UIKit

struct InfoEntity: Codable {
    var title:String = ""
    var value: String = ""
}

enum menu {
    case work
    case live
    case draft
    case discard
}

class UserMenuView: UIView {
    //MARK: - 回调方法
    var infoHandle: ((Int) -> Void)? = nil
    
    //MARK: - 全局变量
    private var infoArr: [InfoEntity]!
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    init(infoArr: [InfoEntity]) {
        self.infoArr = infoArr
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupMenuView()
        self.backgroundColor = .red
    }
    
    private func setupMenuView() {
        let width = Constant.screenWidth / CGFloat(infoArr.count)
        for item in 0..<infoArr.count {
            let subView = UIView()
            self.addSubview(subView)
            subView.tag = 10 + item
            subView.snp.makeConstraints { make in
                make.left.equalTo(CGFloat(item)*width)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(width)
            }
            let titleLabel = setupTitle(with: infoArr[item].title)
            subView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.centerX.width.equalToSuperview()
                make.top.equalTo(5)
                make.height.equalToSuperview().multipliedBy(0.5)
            }
            let valueLabel = setupValue(with: infoArr[item].value)
            subView.addSubview(valueLabel)
            valueLabel.snp.makeConstraints { make in
                make.centerX.width.bottom.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
            }
            subView.backgroundColor = UIColor.random
            subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuAction(_:))))
        }
        
        func setupTitle(with title: String) -> UILabel {
            let label = UILabel()
            label.textAlignment = .center
            label.text = title
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return label
        }
        func setupValue(with value: String) -> UILabel {
            let label = UILabel()
            label.textAlignment = .center
            label.text = value
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            return label
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension UserMenuView {
    @objc private func menuAction(_ tap: UITapGestureRecognizer) {
        if let view = tap.view {
            let tag = view.tag-10
            infoHandle?(tag)
        }
    }
}

