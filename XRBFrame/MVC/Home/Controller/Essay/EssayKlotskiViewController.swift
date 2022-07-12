//
//  EssayKlotskiViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/10.
//
//  华容道页面

import UIKit

class EssayKlotskiViewController: BaseViewController {
    
    //MARK: - 全局变量
    private var templateImageView: UIImageView!
    private var imageViews: [UIImageView] = []
    private var cacheViews: [UIImageView] = []
    
    private let marginLeft = (Constant.screenWidth - 300)/2
    
    //MARK: - 懒加载
    private lazy var resetButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("重置", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(resetIndex), for: UIControl.Event.touchUpInside)
        button.largeEdge = 10
        button.setCornerRadius(5)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        setupTemplateImageView()
        setupItemViews()
        setupResetButton()
    }
    
    private func setupTemplateImageView() {
        templateImageView = UIImageView()
        templateImageView.image = UIImage(named: "ic_car")
        templateImageView.contentMode = .scaleAspectFit
        self.view.addSubview(templateImageView)
        templateImageView.snp.makeConstraints { (make) in
            // 自动布局
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        self.view.layoutIfNeeded()
    }
    
    private func setupItemViews() {
        for row in 0..<3{
            for column in 0..<3 {
                let itemImageView = KlotskiImageView()
                
                // 图片组件尺寸
                var imageFrame: CGRect {
                    let width: CGFloat = 97
                    let height = width
                    let x = CGFloat(column * 100)
                    let y = CGFloat(row * 100)
                    return CGRect(x: x+marginLeft, y: y+250, width: width, height: height)
                }
                
                // 图片内容尺寸
                var imageSize: CGRect {
                    let imageSize = CGSize(width: 640, height: 640)
                    
                    let width = imageSize.width / 3 - 3
                    let height = width
                    let x = CGFloat(column) * imageSize.width / 3
                    let y = CGFloat(row) * imageSize.height / 3
                    return CGRect(x: x, y: y, width: width, height: height)
                }
                
                itemImageView.image = templateImageView.image?.clip(imageSize)
                itemImageView.frame = imageFrame
                itemImageView.addSwipeGestureRecognizer()
                itemImageView.initIndex = column+row*3
                itemImageView.moveHandle = { [weak self] (currentIndex, targetIndex) in
                    self?.moveIndex(currentIndex, targetIndex)
                }
                
                imageViews.append(itemImageView)
                self.view.addSubview(itemImageView)
            }
        }
    }
    
    private func setupResetButton() {
        self.view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(35)
            make.bottom.equalTo(-50)
        }
    }
    
    @objc private func resetIndex() {
        while imageViews.count != 0 {
            //获取一个不超过数组长度的整型随机数
            let i = arc4random_uniform(UInt32(imageViews.count))
            //把在array1这个下标位置的元素添加到array2
            cacheViews.append(imageViews[Int(i)])
            //然后移除该元素
            imageViews.remove(at: Int(i))
        }
        
        for index in 0..<cacheViews.count {
            if let view = cacheViews[index] as? KlotskiImageView {
                view.setUserInteraction(enable: true)
                view.origin = CGPoint(x: CGFloat(index % 3) * 100 + marginLeft, y: CGFloat(index / 3) * 100 + 250)
                view.moveIndex = index
            }
        }
    }
    
    private func moveIndex(_ currentIndex: Int, _ targetIndex: Int) {
        
        
        
        let currentView = cacheViews[currentIndex] as? KlotskiImageView
        let targetView = cacheViews[targetIndex] as? KlotskiImageView
        printLog("选中的图片 - \(currentIndex) - \(currentView!.initIndex), 目标图片 - \(targetIndex) - \(targetView!.initIndex)")
        
        currentView?.moveIndex = targetIndex
        targetView?.moveIndex = currentIndex
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            currentView!.origin = CGPoint(x: CGFloat((targetIndex) % 3) * 100 + self.marginLeft, y: CGFloat((targetIndex) / 3) * 100 + 250)
            targetView! .origin = CGPoint(x: CGFloat((currentIndex) % 3) * 100 + self.marginLeft, y: CGFloat((currentIndex) / 3) * 100 + 250)
        }
    }
}
