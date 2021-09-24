//
//  HomeSearchTextField.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/16.
//
//  首页自定义导航条搜索条组件

import UIKit

public struct SearchTextFieldStyle {
    /// 是否可以编辑
    public var canEdit: Bool = false
    /// 最大长度
    public var maximumLength: Int = 20
    /// 圆角直径
    public var backgroundColor: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    /// 背景颜色
    public var cornerRadius: CGFloat = 12.5
    /// 边框样式
    public var borderStyle: UITextField.BorderStyle = .none
    /// 返回按键样式
    public var returnKeyType: UIReturnKeyType = .search
    /// 键盘样式
    public var keyboardType: UIKeyboardType = .default
    /// 清空模式
    public var clearButtonMode: UITextField.ViewMode = .never
    /// 开始编辑是否清空原有内容
    public var clearsOnBeginEditing: Bool = false
    /// 字体颜色
    public var textColor: UIColor = .black
    /// 字体大小
    public var font: UIFont =  UIFont.systemFont(ofSize: 14, weight: .regular)
    /// 占位文字颜色
    public var placeHolderColor: UIColor =  .darkGray
    /// 占位文字
    public var placeHolder: String = "请输入搜索关键词"
    /// 占位文字大小
    public var placeHolderFont: CGFloat =  12
    /// 左侧视图样式
    public var leftViewMode: UITextField.ViewMode = .always
    /// 右侧视图样式
    public var rightViewMode: UITextField.ViewMode = .whileEditing
    /// 是否启用默认左侧视图
    public var showDefaultLeftView: Bool = true
    /// 左侧视图图片
    public var leftViewImage: UIImage? = UIImage(named: "ic_navigation_search")
    /// 是否启用默认右侧视图
    public var showDefaultRightView: Bool = true
    /// 右侧视图图片
    public var rightViewImage: UIImage? = UIImage(named: "bt_search_close")
}

class HomeSearchTextField: UIView {
    
    //MARK: - 回调方法
    var clearHandle: (() -> Void)? = nil
    var searchHandle: ((String) -> Void)? = nil
    var editingBeginHandle: ((String?) -> Void)? = nil
    var editingChangedHandler: ((String) -> Void)? = nil
    
    //MARK: - 全局变量
    /// 搜索输入框
    private var searchTextField: CustomTextField!
    /// 热门关键词
    private var searchKeys: [String]!
    /// 搜索输入框样式
    private var style: SearchTextFieldStyle!
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    init(style: SearchTextFieldStyle) {
        self.style = style
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupSearchTextField()
    }
    
    private func setupSearchTextField() {
        func getLeftView(frame: CGRect) -> UIView {
            let leftView = UIView()
            leftView.frame = frame
            let searchIcon = UIImageView()
            searchIcon.frame = CGRect(x: (frame.width-frame.height*0.65)/2, y: frame.height*0.175, width: frame.height*0.65, height: frame.height*0.65)
            searchIcon.image = style.leftViewImage
            leftView.addSubview(searchIcon)
            return leftView
        }
        
        func getRightView(frame: CGRect) -> UIView {
            let cleanView = UIView()
            cleanView.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
            
            let cleanButton = UIButton()
            cleanButton.frame = cleanView.frame
            cleanButton.setImage(style.rightViewImage, for: UIControl.State())
            cleanButton.addTarget(self, action: #selector(clearAction), for: UIControl.Event.touchUpInside)
            cleanView.addSubview(cleanButton)
            
            return cleanView
        }
        
        searchTextField = CustomTextField()
        searchTextField.maximumLength = style.maximumLength
        searchTextField.backgroundColor = style.backgroundColor
        searchTextField.borderStyle = style.borderStyle
        searchTextField.returnKeyType = style.returnKeyType
        searchTextField.keyboardType = style.keyboardType
        searchTextField.setCornerRadius(style.cornerRadius)
        searchTextField.clearButtonMode = style.clearButtonMode
        searchTextField.clearsOnBeginEditing = style.clearsOnBeginEditing
        searchTextField.textColor = style.textColor
        searchTextField.font = style.font
        searchTextField.setDefaultAttributedPlaceholder(withPlaceholder: style.placeHolder, color: style.placeHolderColor, fontSize: style.placeHolderFont)
        searchTextField.editingChangedHandler = { [weak self] (value) in
            guard let self = self else {return}
            self.editingChangedHandler?(value)
        }
       
        searchTextField.leftViewMode = style.leftViewMode
        if style.showDefaultLeftView {
            searchTextField.leftView = getLeftView(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        }
        searchTextField.rightViewMode = style.rightViewMode
        if style.showDefaultRightView {
            searchTextField.rightView = getRightView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        }
        searchTextField.delegate = self
        self.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            // 自动布局
            make.left.right.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension HomeSearchTextField {
    @objc private func editingBeginAction(_ textField: UITextField) {
        editingBeginHandle?(textField.placeholder)
    }
    
    func setSearchKeys(_ searchKeys: [String]) {
        self.searchKeys = searchKeys
        showSearchKeys()
    }
    
    /// 设置搜索输入框左侧视图
    func setLeftView(with view: UIView) {
        searchTextField.leftView = view
    }
    
    /// 设置搜索输入框右侧视图
    func setRightView(with view: UIView) {
        searchTextField.rightView = view
    }
    
    /// 清空按钮点击事件
    @objc private func clearAction() {
        searchTextField.clear()
        clearHandle?()
    }
    
    // 设置搜索关键词
    func setSearchKey(_ key: String) {
        searchTextField.text = key
    }
    
    // 计时器展示搜索关键词
    func showSearchKeys() {
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {return}
            if index == self.searchKeys.count{
                index = 0
            }
            self.searchTextField.setDefaultAttributedPlaceholder(withPlaceholder: self.searchKeys[index], color: self.style.placeHolderColor, fontSize: self.style.placeHolderFont)
            index += 1
        }
    }
}

extension HomeSearchTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        editingBeginAction(textField)
        return style.canEdit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchKey = textField.text {
            searchHandle?(searchKey)
        }
        return style.canEdit
    }
}

