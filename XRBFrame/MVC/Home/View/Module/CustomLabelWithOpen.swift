//
//  CustomLabelWithOpen.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2022/3/18.
//
//  可以展开收起的文本展示组件

import UIKit

class CustomLabelWithOpen: UIView {
    
    //MARK: - 回调方法
    var actionHandle: (() -> Void)? = nil
    
    //MARK: - 全局变量
    /// 是否展开
    private var isShow: Bool = false
    private var label: UILabel!
    private var allStr = ""
    private var partStr = ""
    
    //MARK: - 懒加载
    private lazy var showButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("展开", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(showBtnAction), for: UIControl.Event.touchUpInside)
        button.largeEdge = 10
        return button
    }()
    
    //MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        self.backgroundColor = .lightGray
        setupLabel()
        setupShowButton()
    }
    
    private func setupLabel() {
        label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            // 自动布局
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setupShowButton() {
        self.addSubview(showButton)
        showButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(showButton.titleLabel?.font.pointSize ?? 0)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {

    }
}

//MARK: - 选择器事件(自定义方法)
extension CustomLabelWithOpen {
    
    func setValue(with text: String) {
        self.allStr = text
        self.label.text = text
        self.layoutIfNeeded()
        getPartString()
        resetButton()
    }
    func resetButton() {
        showButton.isHidden = label.getRealLabelTextLines() <= 2
        label.numberOfLines = 2
        self.layoutIfNeeded()
    }
    func resetLabel(by showAll: Bool) {
        if showAll {
            self.label.text = allStr
        } else {
            getPartString()
        }
    }
    
    func getPartString() {
        guard let text = label.text else {return}
        if !partStr.isEmpty { // 已经获取到了临时数据
            self.label.text = partStr
            return
        }
        //TODO: - 获取临时数据
        var strArr: [String] = []
        var total: (width: CGFloat, index: Int) = (0.0, 0)
        for index in 0..<text.length {
            guard let str = text.substring(from: index, to: index+1) else {return}
            strArr.append(str)
            partStr+=str
            let width = str.getNormalStrW(str: str, strFont: label.font.pointSize, h: 20)
            total.width += width
            if total.width > label.width {
                total.index += 1
                total.width = width
            }
            if total.index > 0, total.width > label.width - 80.0 {
                print(strArr)
                partStr += "..."
                break
            }
        }
        print(partStr)
        self.label.text = partStr
        print("完成")
    }
    @objc
    private func showBtnAction() {
        isShow = !isShow
        label.numberOfLines = isShow ? 0 : 2
        showButton.setTitle(isShow ? "收起" : "展开", for: .normal)
        resetLabel(by: isShow)
        label.snp.remakeConstraints { make in
            if isShow {
                make.left.equalTo(20)
                make.right.bottom.equalTo(-20)
                make.top.equalToSuperview()
            } else {
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.top.bottom.equalToSuperview()
            }
        }
    }
}

extension UILabel {
    //计算label的行数
    func getRealLabelTextLines() -> Int {
        //计算理论上需要的行数
        let labelTextLines = Int(self.bounds.height / self.font.lineHeight)
        return labelTextLines
    }
}
