//
//  ShareView.swift
//  HiconMultiScreen
//
//  Created by devchena on 2020/11/26.
//

import UIKit

enum ShareStyle {
    /// 默认
    case `default`
    /// 横屏
    case landscape
    /// 导播横屏
    case broadcast_landscape
    /// 导播竖屏
    case broadcast_portrait
}

class ShareView: UIView {
    var selectHandler: ShareSelectHandler?
    
    private let style: ShareStyle
    private let types: [ShareType]

    private var backgroundView: UIView!
    private var visualEffectView: UIVisualEffectView!

    init(style: ShareStyle) {
        self.style = style
        if style == .default || style == .landscape {
            types = [.wxSceneSession, .wxSceneTimeline, .qqFriends, .copy, .report]
        } else {
            types = [.wxSceneSession, .wxSceneTimeline, .qqFriends, .copy]
        }
        super.init(frame: UIScreen.main.bounds)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        visualEffectView.roundCorners([.topLeft, .topRight], radius: 12.0)
    }
    
    private func setup() {
        backgroundView = UIView()
        backgroundView.alpha = 0.0
        addSubview(backgroundView)
        backgroundView.backgroundColor = Color.mask
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundView))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        addSubview(visualEffectView)
        setContentViewConstraints(isShow: false)

        let contentView = visualEffectView.contentView
        let isLandscape = style == .landscape || style == .broadcast_landscape
        let isXSeries = UIDevice.current.isXSeries()

        let titleLabel = UILabel()
        titleLabel.text = "分享到"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            if isLandscape {
                make.centerX.equalToSuperview()
            } else {
                make.left.equalTo(16)
            }
        }

        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "ic_view_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        contentView.addSubview(closeBtn)
        
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(isLandscape && isXSeries ? -Constant.dangerousAreaHeight : -16)
            make.top.equalTo(16)
            make.width.height.equalTo(24)
        }

        let minimumLineSpacing: CGFloat = 20.0
        let itemSize: CGSize = .init(width: 48.0, height: 72.0)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = minimumLineSpacing
        layout.scrollDirection = .horizontal
        layout.itemSize = itemSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ShareCell.self, forCellWithReuseIdentifier: "ShareCell")
        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            if isLandscape {
                let count = CGFloat(types.count)
                let width = count * itemSize.width + (count - 1.0) * minimumLineSpacing
                make.width.equalTo(width)
            } else {
                make.width.equalToSuperview()
            }
            make.height.equalTo(72)
        }
    }
    
    private func setContentViewConstraints(isShow: Bool) {
        visualEffectView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(193)
            if isShow {
                make.bottom.equalTo(snp.bottom)
            } else {
                make.top.equalTo(snp.bottom)
            }
        }
    }
}

extension ShareView {
    func show(in view: UIView) {
        DispatchQueue.main.async {
            view.addSubview(self)
            view.bringSubviewToFront(self)
            
            self.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            view.layoutIfNeeded()

            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundView.alpha = 1.0
                self.setContentViewConstraints(isShow: true)
                self.layoutIfNeeded()
            })
        }
    }

    private func hide() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0.0
            self.setContentViewConstraints(isShow: false)
            self.layoutIfNeeded()
        } completion: { (finish) in
            self.removeFromSuperview()
        }
    }
}

extension ShareView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareCell", for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ShareCell, indexPath.row < types.count else {
            return
        }
        cell.show(type: types[indexPath.row])
    }
            
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < types.count else {
            return
        }
        hide()
        selectHandler?(types[indexPath.row])
    }
}

extension ShareView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch style {
        case .default, .broadcast_portrait:
            return .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        case .landscape, .broadcast_landscape:
            return .zero
        }
    }
}

extension ShareView {
    @objc private func closeBtnClicked() {
        hide()
    }
    
    @objc private func tapBackgroundView() {
        hide()
    }
}
