//
//  ScanViewController.swift
//  BasicProgram
//
//  Created by 谢汝滨 on 2020/9/14.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import swiftScan

struct ScanResult {
    /// 码内容
    var strScanned: String?
    /// 扫描图像
    var imgScanned: UIImage?
    /// 码的类型
    var strBarCodeType: String?
    /// 码在图像中的位置
    var arrayCorner: [AnyObject]?

    init(str: String?, img: UIImage?, barCodeType: String?, corner: [AnyObject]?) {
        strScanned = str
        imgScanned = img
        strBarCodeType = barCodeType
        arrayCorner = corner
    }
}

protocol ScanDelegate: class {
    /// 扫描完成
    func scanFinished(scanResult: ScanResult, error: String?)
}

class ScanViewController: LBXScanViewController {
    weak var scanDelegate: ScanDelegate?

    private var isFirstAppearance: Bool = true

    private lazy var navigationBar: CustomNavigationBar = {
        let navigationBar = CustomNavigationBar()
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.backImage = UIImage(named: "ic_navigation_back")
        navigationBar.titleColor = UIColor.white
        navigationBar.title = "扫一扫"
        navigationBar.delegate = self
        return navigationBar
    }()

    private lazy var photoAlbumBtn: UIButton = {
        let photoAlbumBtn = UIButton()
        photoAlbumBtn.setTitle("相册", for: .normal)
        photoAlbumBtn.setTitleColor(UIColor.white, for: .normal)
        photoAlbumBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        photoAlbumBtn.addTarget(self, action: #selector(clickPhotoAlbumBtn), for: .touchUpInside)
        return photoAlbumBtn
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "请扫描电视屏幕上的二维码"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        return titleLabel
    }()
    
    private lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.isUserInteractionEnabled = true
        tipsLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tipsLabel.text = "  在TV上找码？"
        tipsLabel.textAlignment = .center
        tipsLabel.textColor = UIColor.white
        tipsLabel.font = UIFont.systemFont(ofSize: 15.0)
        tipsLabel.setCornerRadius(20.0, masksToBounds: true)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTipsLabel))
        tipsLabel.addGestureRecognizer(tapGestureRecognizer)
        return tipsLabel
    }()
    
    private let scanTop: CGFloat = Constant.navigationBarHeight + 90.0
    private let scanHeight: CGFloat = Constant.screenWidth - 120.0
    private lazy var scanBottom: CGFloat = {
        return scanTop + scanHeight
    }()
    private lazy var centerUpOffset: CGFloat = {
        let height: CGFloat = Constant.screenWidth - 120.0
        let offset: CGFloat = 0.5 * (Constant.screenWidth - scanHeight) - scanTop
        return -offset
    }()
    
    private lazy var scanViewStyle: LBXScanViewStyle = {
        var style = LBXScanViewStyle()
        style.anmiationStyle = .LineMove
        style.photoframeAngleStyle = .Inner
        style.centerUpOffset = centerUpOffset
        style.photoframeLineW = 2.0
        style.photoframeAngleW = 18.0
        style.photoframeAngleH = 18.0
        style.colorRetangleLine = UIColor.gray
        style.colorAngle = Color.theme
        style.color_NotRecoginitonArea = UIColor.black.withAlphaComponent(0.3)
        style.animationImage = UIImage(named: "ic_scan_line")
        return style
    }()

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        drawScanView()
        startScan()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirstAppearance {
            isFirstAppearance = false
        } else {
            drawScanView()
            perform(#selector(LBXScanViewController.startScan), with: nil, afterDelay: 0.3)
        }
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.bringSubviewToFront(navigationBar)
        view.bringSubviewToFront(titleLabel)
        view.bringSubviewToFront(tipsLabel)
    }

    private func setupView() {
        // 设置扫码区域参数
        scanStyle = scanViewStyle
        readyString = "启动中..."

        view.addSubview(navigationBar)
        navigationBar.addSubview(photoAlbumBtn)

        photoAlbumBtn.snp.makeConstraints { (make) in
            make.top.equalTo(Constant.statusBarHeight)
            make.right.equalTo(-10)
            make.width.equalTo(56)
            make.height.equalTo(44)
        }

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(scanBottom + 24.0)
            make.height.equalTo(18)
        }
        
        view.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(64)
            make.width.equalTo(116)
            make.height.equalTo(40)
        }
    }

    /// 重写扫描完成
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        guard let delegate = scanDelegate else {
            fatalError("you must set scanResultDelegate or override this method without super keyword")
        }
        navigationController?.popViewController(animated: true)
        if let result = arrayResult.first {
            let result = ScanResult(str: result.strScanned,
                                    img: result.imgScanned,
                                    barCodeType: result.strBarCodeType,
                                    corner: result.arrayCorner)
            delegate.scanFinished(scanResult: result, error: nil)
        } else {
            let result = ScanResult(str: nil, img: nil, barCodeType: nil, corner: nil)
            delegate.scanFinished(scanResult: result, error: "no scan result")
        }
    }
}

extension ScanViewController {
    @objc private func clickPhotoAlbumBtn() {
        openPhotoAlbum()
    }
    
    @objc private func tapTipsLabel() {
        //Main.currentViewController?.pushVC(BindingIPTVViewController())
    }
}

extension ScanViewController: CustomNavigationBarDelegate {
    func goback(_ navigationBar: CustomNavigationBar) {
        popVC()
    }
}
