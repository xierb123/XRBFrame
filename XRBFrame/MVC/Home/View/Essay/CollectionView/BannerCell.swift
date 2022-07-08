//
//  BannerCell.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/9/28.
//
//  bannercell

import UIKit
import FSPagerView

class BannerCell: UICollectionViewCell {
    //MARK: - 标识符
    static let identifier = "BannerCell"
    
    //MARK: - 全局变量
    private var models: [BannerEntity]!
    private var currentCell: BannerPagerCell!
    
    //MARK: - 懒加载
    lazy var viewPager: FSPagerView = {
        let viewPager = FSPagerView()
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.register(BannerPagerCell.self, forCellWithReuseIdentifier: "BannerPagerCell")
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 8.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 8.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        //设置转场的模式
        viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.overlap)
        return viewPager
    }()
    lazy var pagerControl:FSPageControl = {
        let pageControl = FSPageControl()
        //设置下标位置
        pageControl.contentHorizontalAlignment = .center
        //设置下标指示器边框颜色（选中状态和普通状态）
        pageControl.setStrokeColor(.white, for: .normal)
        pageControl.setStrokeColor(.gray, for: .selected)
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(.gray, for: .selected)
        //设置下标指示器图片（选中状态和普通状态）
        //pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        //pageControl.setImage(UIImage.init(named: "2"), for: .selected)
        //绘制下标指示器的形状 (roundedRect绘制绘制圆角或者圆形)
        pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 5, height: 5),cornerRadius: 4.0), for: UIControl.State())
        //pageControl.setPath(UIBezierPath(rect: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
        //pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .selected)
        return pageControl
        
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
        setupBannerView()
    }
    
    /// 设置滚动条布局
    private func setupBannerView() {
        self.contentView.addSubview(viewPager)
        viewPager.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(pagerControl)
        pagerControl.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
        }
    }
    
    //MARK: - 生命周期函数
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - 选择器事件(自定义方法)
extension BannerCell: BindData {
    /// 数据填充
    func bindData(_ data: Any?) {
        if let viewModel:CellViewModel = data as? CellViewModel{ // 数据是一个封装的模型
            if let models = viewModel.data as? [BannerEntity]{
                self.models = models
                pagerControl.numberOfPages = models.count
                viewPager.reloadData()
            }
        }
    }
}

extension BannerCell: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return models.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: BannerPagerCell.identifier, at: index) as! BannerPagerCell
        cell.show(index: index)
        return cell
    }
    
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pagerControl.currentPage = index
        
        printLog("即将出现 - \(index)")
        if let cell = cell as? BannerPagerCell {
            currentCell = cell
        }
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        printLog("完全出现 - \(index)")
        currentCell.startAnimation()
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        printLog("完全出现 - \(index)")
        currentCell.startAnimation()
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        printLog("完全移除 - \(index)")
        if let cell = cell as? BannerPagerCell {
            cell.endAnimation()
        }
    }
    
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.routerEvent(Comment(event: .clicked(index), type: BannerCell.identifier))
    }
}



