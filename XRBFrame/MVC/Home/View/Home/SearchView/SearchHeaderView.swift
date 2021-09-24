//
//  SearchHeaderView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/23.
//
//  搜索历史视图组件

import UIKit

class SearchHeaderView: UIView {
    
    //MARK: - 回调方法
    var clearHandle: (() -> Void)? = nil
    var tagHandle: ((SearchEntity) -> Void)? = nil
    
    //MARK: - 全局变量
    /// 标题栏
    private var titleLabel: UILabel!
    /// 主视图
    private var contentView: UIView!
    /// 清空按钮
    private var clearButton: UIButton!
    /// 分割线
    private var separator: UIView!
    /// 单个标签最大字数
    private var maxCount: CGFloat = 20
    /// 字号
    private var font: CGFloat = 14
    /// 单个标签最大宽度
    private var maxLength: CGFloat {
        return maxCount * font
    }
    
    //MARK: - 懒加载
    
    //MARK: - init/deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    /*init(<#parameter#>: <#Object#>) {
     super.init(frame: .zero)
     
     setupView()
     }*/
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupTitleLable()
        setupClearButton()
        setupContentView()
        setupSeparator()
    }
    
    private func setupTitleLable() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.text = "搜索历史"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(Constant.margin)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(100)
            make.height.equalTo(16)
        }
    }
    
    private func setupClearButton(){
        clearButton = UIButton()
        clearButton.setImage(UIImage(named: "bt_search_clean"), for: UIControl.State())
        clearButton.addTarget(self, action: #selector(clearButtonAction), for: UIControl.Event.touchUpInside)
        clearButton.frame = CGRect(x: Constant.screenWidth-40, y: 9, width: 28, height: 28)
        addSubview(clearButton)
    }
    
    private func setupContentView() {
        contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(Constant.margin)
            make.right.equalTo(-Constant.margin)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func setupSeparator() {
        separator = UIView()
        separator.backgroundColor = Color.separator
        addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        
    }
}

//MARK: - 选择器事件(自定义方法)
extension SearchHeaderView {
    
    @objc private func clearButtonAction() {
        clearHandle?()
    }
    
    @objc private func tagAction(_ tap:UITapGestureRecognizer){
        //self.delegate?.historeSearch(key: (tap.view as! UILabel).text!)
        if let title = (tap.view as! UILabel).text {
            let entity = SearchEntity(searchName: title)
            tagHandle?(entity)
        }
    }
    
    /// 设置标签组
    func showLabels(titles: [String]) {
        let originY:CGFloat = 21.0
        contentView.removeSubviews()
        guard titles.count >= 1 else{
            clearButton.isHidden = true
            return
        }
        
        clearButton.isHidden = false
        var totalWidth:CGFloat = 0.0
        var row:CGFloat = 0
        let tagWidth:CGFloat = 18
        let tagHeight:CGFloat = 26
        
        var titleArr = titles
        titleArr.reverse()
        for item in 0...titleArr.count{
            guard item < titleArr.count else{
                return
            }
            let label = UILabel()
            label.text = titleArr[item]
            label.backgroundColor = UIColor(white: 0, alpha: 0.04)
            label.textColor = UIColor(hexString: "#1A1A1A")
            label.font = UIFont.systemFont(ofSize: 14)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagAction(_:))))
            label.textAlignment = .center
            label.setCornerRadius(4, masksToBounds: true)
            contentView.addSubview(label)
            let width:CGFloat = label.getLabelWidth()+tagWidth > maxLength ? maxLength : label.getLabelWidth()+tagWidth
            var tagX:CGFloat = 0
            if item > 0{
                let nextLabel = UILabel()
                nextLabel.font = label.font
                nextLabel.text = titleArr[item-1]
                tagX = nextLabel.getLabelWidth()+tagWidth*1.5 > maxLength ? maxLength : nextLabel.getLabelWidth()+tagWidth*1.5
            }
            totalWidth = totalWidth+tagX+width > Constant.screenWidth-2*Constant.margin ? 0 : totalWidth+tagX
            row = totalWidth == 0 ? row+1 : row;
            
            label.snp.makeConstraints { (make) in
                make.left.equalTo(totalWidth)
                make.width.equalTo(width)
                make.top.equalTo((row-1)*(tagHeight+12)+originY)
                make.height.equalTo(tagHeight)
            }
            
            if item == titleArr.count - 1 {
                label.snp.makeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(0)
                }
            }
        }
    }
}
