//
//  SearchCustomNavigationBar.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/23.
//
//  搜索页面导航条视图组件

import UIKit

class SearchCustomNavigationBar: UIView {
    
    //MARK: - 回调方法
    var backHandle: (() -> Void)? = nil
    var clearHandle: (() -> Void)? = nil
    var searchHandle: ((SearchEntity) -> Void)? = nil
    
    //MARK: - 全局变量
    /// 搜索占位
    private var placeHolder: String = ""
    /// 返回按钮
    private var backButton: UIButton!
    /// 字数限制
    private var maximumLength: Int = 20
    /// 搜索输入框
    private var searchTextField: HomeSearchTextField!
    /// 搜索按钮
    private var searchButton: UIButton!
    /// 搜索关键词
    private var searchKey: String = ""
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    init(placeHolder: String) {
        self.placeHolder = placeHolder
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        setupBackButton()
        setupSearchButton()
        setupSearchTextField()
    }
    
    private func setupBackButton() {
        backButton = UIButton()
        backButton.setImage(UIImage(named: "ic_navigation_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(Constant.statusBarHeight + Constant.navigationBarHeight / 2.0)
            make.width.height.equalTo(24)
        }
    }
    
    private func setupSearchButton() {
        searchButton = UIButton()
        searchButton.setTitle("取消", for: UIControl.State.normal)
        searchButton.setTitleColor(.white, for: UIControl.State.normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        searchButton.addTarget(self, action: #selector(searchAction(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            // 自动布局
            make.right.equalTo(-Constant.margin)
            make.height.equalTo(35)
            make.width.equalTo(50)
            make.centerY.equalTo(backButton)
        }
    }
    
    private func setupSearchTextField() {
        var style = SearchTextFieldStyle()
        style.cornerRadius = 4
        style.placeHolder = placeHolder
        style.maximumLength = maximumLength
        style.showDefaultLeftView = true
        style.canEdit = true
        searchTextField = HomeSearchTextField(style: style)
        searchTextField.editingChangedHandler = { [weak self] (value) in
            guard let self = self else {return}
            self.searchKey = value
            self.searchButton.setTitle(value.isEmpty ? "取消" : "搜索", for: .normal)
        }
        searchTextField.clearHandle = { [weak self] in
            self?.searchButton.setTitle("取消", for: .normal)
            self?.clearHandle?()
        }
        searchTextField.searchHandle = { [weak self] (searchKey) in
            guard let self = self else {return}
            let entity = SearchEntity(searchName: searchKey)
            self.searchHandle?(entity)
        }
        self.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(Constant.margin)
            make.centerY.height.equalTo(searchButton)
            make.height.equalTo(35)
            make.right.equalTo(searchButton.snp.left).offset(-Constant.margin)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension SearchCustomNavigationBar {
    
    @objc private func backAction() {
        backHandle?()
    }
    
    @objc private func searchAction(_ btn: UIButton) {
        if let title = btn.titleLabel?.text {
            if title == "搜索"{
                let entity = SearchEntity(searchName: searchKey)
                self.searchHandle?(entity)
            } else {
                backHandle?()
            }
        }
    }
    
    // 设置搜索关键词
    func setSearchKey(_ key: String) {
        searchTextField.setSearchKey(key)
        searchButton.setTitle(key.isEmpty ? "取消" : "搜索", for: .normal)
    }
}
