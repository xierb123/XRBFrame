//
//  VerificationCodeView.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/2.
//
//  验证码输入框视图组件

import UIKit

/// 验证码输入框样式
public struct VerificationCodeViewStyle {
    /// 验证码位数
    public var codeCount: Int = 4
    /// 输入框之间的间距
    public var marginForLabel: CGFloat = 12.0
    /// 输入框宽度
    public var labelWidth: CGFloat = 44.0
    /// 输入框高度
    public var labelHeight: CGFloat = 50.0
    /// 输入框字号
    public var textFont: UIFont = UIFont.systemFont(ofSize: 24, weight: .medium)
    /// 输入框字体颜色
    public var textColor: UIColor = .white
    /// 输入框背景色
    public var textBackgroundColor: UIColor = .gray
    /// 输入框圆角
    public var cornerRadius: CGFloat = 4
    /// 输入框光标宽度
    public var cursorWidth: CGFloat = 2.0
    /// 输入框光标高度
    public var cursorHeight: CGFloat {
        return labelHeight-28
    }
}

class VerificationCodeView: UIView {
    
    //MARK: - 回调方法
    var codeHandle: ((String) -> Void)? = nil
    
    //MARK: - 全局变量
    /// 输入框样式
    private var style: VerificationCodeViewStyle!
    /// 输入框
    private var textField: UITextField!
    /// 展示的label数组
    private var labels: [CursorLabel] = []
    /// 当前展示的label
    private var currentLabel: CursorLabel!
    /// 输入框的覆盖层
    private var coverView: UIView!
    
    
    //MARK: - init/deinit
    init(style: VerificationCodeViewStyle) {
        self.style = style
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupTextField()
        setupLabels()
    }
    
    // 创建输入框
    private func setupTextField() {
        textField = UITextField()
        textField.backgroundColor = .white
        textField.autocapitalizationType = .none
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(tfEditingChanged(_:)), for: .editingChanged)
        addSubview(textField)
        
        // 小技巧：通过textField上层覆盖一个maskView，可以去掉textField的长按事件
        coverView = UIView()
        coverView.backgroundColor = .clear
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickMaskView)))
        addSubview(coverView)
    }
    
    // 创建展示的label
    private func setupLabels() {
        for _ in 0..<style.codeCount {
            let label = CursorLabel(style: style)
            label.textAlignment = NSTextAlignment.center
            label.textColor = style.textColor
            label.backgroundColor = style.textBackgroundColor
            label.font = style.textFont
            addSubview(label)
            labels.append(label)
        }
    }
    
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        if labels.count != style.codeCount {
            return
        }

        let temp = style.marginForLabel * CGFloat(style.codeCount - 1)
        let w:CGFloat = style.labelWidth
        let h:CGFloat = style.labelHeight
        let marginLeft = (width-temp-CGFloat(style.codeCount)*w)/2
        var x: CGFloat = 0
        let y: CGFloat = (height-style.labelHeight)/2
        
        for i in 0..<labels.count {
            x = CGFloat(i) * (w + style.marginForLabel) + marginLeft

            let label = labels[i]
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            if style.cornerRadius > 0 {
                label.setCornerRadius(style.cornerRadius, masksToBounds: true)
            }
        }

        textField?.frame = .zero
        coverView?.frame = bounds
    }
}

//MARK: - 选择器事件(自定义方法)
extension VerificationCodeView {
    /// 编辑状态改变
    @objc private func tfEditingChanged(_ textField: UITextField?) {
        if let text = textField?.text{
            codeHandle?(text)
        }
        
        if (textField?.text?.count ?? 0) > style.codeCount {
            textField?.text = (textField?.text as NSString?)?.substring(with: NSRange(location: 0, length: style.codeCount))
        }

        for i in 0..<style.codeCount {
            let label = labels[i]

            if i < (textField?.text?.count ?? 0) {
                label.text = (textField?.text as NSString?)?.substring(with: NSRange(location: i, length: 1))
            } else {
                label.text = nil
            }
        }
        cursor()

        // 输入完毕后，自动隐藏键盘
        if (textField?.text?.count ?? 0) >= style.codeCount {
            currentLabel?.stopAnimating()
            textField?.resignFirstResponder()
        }
        print(textField?.text ?? "数据清空")
    }
    
    @objc private func clickMaskView() {
        textField?.becomeFirstResponder()
        cursor()
    }

    /// 编辑结束
    @objc override func endEditing(_ force: Bool) -> Bool {
        textField?.endEditing(force)
        currentLabel?.stopAnimating()
        return super.endEditing(force)
    }

    /// 处理光标
    private func cursor() {
        currentLabel?.stopAnimating()

        var index = code()?.count ?? 0
        if index < 0 {
            index = 0
        }
        if index >= labels.count {
            index = labels.count - 1
        }

        let label = labels[index]

        label.startAnimating()
        currentLabel = label
    }

    /// 获取到验证码
    func code() -> String? {
        return textField?.text
    }
    
    /// 清空验证码
    func clearCode() {
        for item in labels {
            item.text = ""
        }
        textField?.text = ""
        textField?.becomeFirstResponder()
        cursor()
    }
}

//  验证码输入框单个label视图组件

import UIKit

class CursorLabel: UILabel {
    //MARK: - 全局变量
    private var cursorView: UIView!
    /// 输入框样式
    private var style: VerificationCodeViewStyle!
    
    //MARK: - init/deinit
    init(style: VerificationCodeViewStyle) {
        self.style = style
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI布局
    private func setupView() {
        setupCursorView()
    }
    
    private func setupCursorView() {
        cursorView = UIView()
        cursorView.backgroundColor = UIColor.white
        cursorView.alpha = 0
        addSubview(cursorView)
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        let h: CGFloat = style.cursorHeight
        let w: CGFloat = style.cursorWidth
        let x: CGFloat = bounds.size.width * 0.5
        let y: CGFloat = bounds.size.height * 0.5
        cursorView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        cursorView.center = CGPoint(x: x, y: y)
    }
}

//MARK: - 选择器事件(自定义方法)
extension CursorLabel {
    /// 开始光标闪动动画
    func startAnimating() {
        if let text = self.text {
            if text.length > 0 {
                return
            }
        }
        let oa = CABasicAnimation(keyPath: "opacity")
        oa.fromValue = NSNumber(value: 0)
        oa.toValue = NSNumber(value: 1)
        oa.duration = 1
        oa.repeatCount = MAXFLOAT
        oa.isRemovedOnCompletion = false
        oa.fillMode = .forwards
        oa.timingFunction = CAMediaTimingFunction(name: .easeIn)
        cursorView.layer.add(oa, forKey: "opacity")
    }
        
    /// 结束光标闪动动画
    func stopAnimating() {
        cursorView.layer.removeAnimation(forKey: "opacity")
    }
}


