//
//  CategoryHeaderView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/20.
//
//  类别表格头部组件

class CategoryHeaderView: UICollectionReusableView {
    
    //MARK: - 标识符
    static let identifier = "CategoryHeaderView"
    
    //MARK: - 回调方法
    var clickCallback: (() -> ())? = nil
    
    //MARK: - 全局变量
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    //MARK: - 懒加载
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("编辑", for: .normal)
        button.setTitle("完成", for: .selected)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.frame = CGRect(x: Constant.screenWidth - 80, y: 0, width: 80, height: self.frame.height)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    private lazy var label: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.frame.origin.x = 20
        return label
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
        // 设置UI
        addSubview(label)
        addSubview(button)
        backgroundColor = UIColor.groupTableViewBackground
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension CategoryHeaderView {
    @objc func buttonAction() {
        clickCallback?()
    }
}
