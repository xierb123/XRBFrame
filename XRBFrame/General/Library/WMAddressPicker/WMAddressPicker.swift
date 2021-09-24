//
//  YMAreaController.swift
//  RefuelNow
//
//  Created by Winson Zhang on 2018/12/19.
//  Copyright © 2018 LY. All rights reserved.
//

import UIKit
import IBAnimatable

typealias Area = (name: String, code: Int)
typealias AreaAction = (_ province: Area, _ city: Area?, _ district: Area?) -> Void

private let ScreenWidth = UIScreen.main.bounds.width
private let ScreenHeight = UIScreen.main.bounds.height

private let provinceCellId = "provinceCell"
private let cityCellId = "cityCell"
private let districtCellId = "districtCell"

private enum TableViewType: Int { case province = 100, city = 200, distrcit = 300 }

class WMAddressPicker: AnimatableModalViewController {
    /// 选择回调
    var selectedAreaCompleted: AreaAction?
    /// 精确度（精确到几级，最多3级）
    var accuracy: Int = 3 {
        didSet {
            if accuracy > 0 && accuracy < 4 {
                _accuracy = accuracy
            } else {
                _accuracy = 3
            }
        }
    }
    
    private var _accuracy: Int = 3

    @IBOutlet weak var scrollViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var provinceButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var districtButton: UIButton!
    private var buttons: [UIButton] = []
    private var province_tb: UITableView?
    private var city_tb: UITableView?
    private var district_tb: UITableView?
    private var provinces: [Province] = []
    private var cities: [City] = []
    private var districts: [District] = []
    private var provinceSelIndexPath: IndexPath?
    private var citySelIndexPath: IndexPath?
    private var districtSeIndexPath: IndexPath?
    
    private var sel_province: Province = Province() {
        didSet {
            provinceButton.setTitle(sel_province.name, for: UIControl.State.normal)
            if _accuracy == 1 {
                cityButton.setTitle(nil, for: UIControl.State.normal)
                districtButton.setTitle(nil, for: UIControl.State.normal)
                cityButton.isUserInteractionEnabled = false
                districtButton.isUserInteractionEnabled = false
            } else if _accuracy == 2 {
                cityButton.setTitle("请选择", for: UIControl.State.normal)
                districtButton.setTitle(nil, for: UIControl.State.normal)
                districtButton.isUserInteractionEnabled = false
            }
        }
    }
    
    private var sel_city: City = City() {
        didSet {
            if _accuracy == 1 {
                cityButton.setTitle(nil, for: UIControl.State.normal)
                districtButton.setTitle(nil, for: UIControl.State.normal)
                cityButton.isUserInteractionEnabled = false
                districtButton.isUserInteractionEnabled = false
            } else if _accuracy == 2 {
                cityButton.setTitle(sel_city.name, for: UIControl.State.normal)
                districtButton.setTitle(nil, for: UIControl.State.normal)
                districtButton.isUserInteractionEnabled = false
            } else {
                cityButton.setTitle(sel_city.name, for: UIControl.State.normal)
                districtButton.setTitle("请选择", for: UIControl.State.normal)
            }
        }
    }
    
    private var sel_district: District = District() {
        didSet {
            districtButton.setTitle(sel_district.name, for: UIControl.State.normal)
        }
    }

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
        loadData()
    }
}

extension WMAddressPicker {
    private func setupView() {
        view.roundCorners([.topLeft, .topRight], radius: 10.0)
        setupTalbeView()
        setupButtons()
    }

    private func setupTalbeView() {
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        province_tb = factoryTableView(type: .province, cellIdentifier: provinceCellId)
        scrollView.addSubview(province_tb!)
        city_tb = factoryTableView(type: .city, cellIdentifier: cityCellId)
        scrollView.addSubview(city_tb!)
        district_tb = factoryTableView(type: .distrcit, cellIdentifier: districtCellId)
        scrollView.addSubview(district_tb!)
    }
    
    private func setupButtons() {
        provinceButton.isSelected = true
        buttons = [provinceButton, cityButton, districtButton]
        _ = buttons.map {
            $0.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            $0.setTitleColor(UIColor.black, for: UIControl.State.selected)
        }
    }
}

extension WMAddressPicker {
    private func loadData() {
        if let provinces = AddressManager.provinces {
            self.provinces = provinces
        } else {
            guard let path = Bundle.main.path(forResource: "area.json", ofType: nil) else {
                return
            }
            guard let data = NSData(contentsOfFile: path) else {
                return
            }

            let jsonData = Data(referencing: data)
            guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] else {
                return
            }
            guard let provinces = try? Mapper<Province>.mapArray(jsonArray: json) else {
                return
            }

            self.provinces = provinces
        }

        province_tb?.reloadData()
    }
}

extension WMAddressPicker: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = TableViewType(rawValue: tableView.tag)!
        switch type {
        case .province:
            return provinces.count
        case .city:
            return cities.count
        case .distrcit:
            return districts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = TableViewType(rawValue: tableView.tag)!
        switch type {
        case .province:
            let cell = tableView.dequeueReusableCell(withIdentifier: provinceCellId, for: indexPath) as! WMAddressCell
                cell.nameLabel?.text = provinces[indexPath.row].name
                cell.isSelect = indexPath == provinceSelIndexPath
            return cell
        case .city:
            let cell = tableView.dequeueReusableCell(withIdentifier: cityCellId, for: indexPath) as! WMAddressCell
            cell.nameLabel?.text = cities[indexPath.row].name
            cell.isSelect = indexPath == citySelIndexPath
            return cell
        case .distrcit:
            let cell = tableView.dequeueReusableCell(withIdentifier: districtCellId, for: indexPath) as! WMAddressCell
            if districts.count > 0 {
                cell.nameLabel?.text = districts[indexPath.row].name
                cell.isSelect = indexPath == districtSeIndexPath
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = TableViewType(rawValue: tableView.tag)!
        switch type {
            
        case .province:
            if let provinceSelIndexPath = provinceSelIndexPath {
                let cell = tableView.cellForRow(at: provinceSelIndexPath) as? WMAddressCell
                cell?.isSelect = false
                if provinceSelIndexPath != indexPath {
                    citySelIndexPath = nil
                    districtSeIndexPath = nil
                }
            }
            provinceSelIndexPath = indexPath
            self.sel_province = self.provinces[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as! WMAddressCell
            cell.isSelect = true
            
            if _accuracy == 1 {
                let province: Area = (sel_province.name, sel_province.code)
                selectedAreaCompleted?(province, nil, nil)
                dismissButtonClicked()
            } else {
                cities = provinces[indexPath.row].cities
                scrollView.contentSize = CGSize(width: ScreenWidth * 2.0, height: scrollViewHeight)
                city_tb?.reloadData()
                scrollView.setContentOffset(CGPoint(x: ScreenWidth, y: 0.0), animated: true)
            }
            
        case .city:
            if let citySelIndexPath = citySelIndexPath {
                let cell = tableView.cellForRow(at: citySelIndexPath) as? WMAddressCell
                cell?.isSelect = false
                if citySelIndexPath != indexPath { districtSeIndexPath = nil }
            }
            citySelIndexPath = indexPath
            self.sel_city = self.cities[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as! WMAddressCell
            cell.isSelect = true
            
            if _accuracy == 3 {
                districts = cities[indexPath.row].districts
                if districts.count > 0 {
                    scrollView.contentSize = CGSize(width: ScreenWidth * 3.0, height: scrollViewHeight)
                    district_tb?.reloadData()
                    scrollView.setContentOffset(CGPoint(x: ScreenWidth * 2.0, y: 0.0), animated: true)
                } else {
                    district_tb?.reloadData()

                    let province: Area = (sel_province.name, sel_province.code)
                    let city: Area = (sel_city.name, sel_city.code)
                    selectedAreaCompleted?(province, city, nil)
                    dismissButtonClicked()
                }
            } else {
                let province: Area = (sel_province.name, sel_province.code)
                let city: Area = (sel_city.name, sel_city.code)
                selectedAreaCompleted?(province, city, nil)
                dismissButtonClicked()
            }
            
        case .distrcit:
            if let districtSeIndexPath = districtSeIndexPath {
                let cell = tableView.cellForRow(at: districtSeIndexPath) as? WMAddressCell
                cell?.isSelect = false
            }
            districtSeIndexPath = indexPath
            let cell = tableView.cellForRow(at: indexPath) as! WMAddressCell
            cell.isSelect = true
            sel_district = districts[indexPath.row]

            let province: Area = (sel_province.name, sel_province.code)
            let city: Area = (sel_city.name, sel_city.code)
            let district: Area = (sel_district.name, sel_district.code)
            selectedAreaCompleted?(province, city, district)
            dismissButtonClicked()
        }
    }
}

extension WMAddressPicker {
    @IBAction func dismissButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func areaButtonClicked(_ sender: UIButton) {
        
       let type = TableViewType(rawValue: sender.tag)
        switch type! {
            case .province: scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            case .city: scrollView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
            case .distrcit: scrollView.setContentOffset(CGPoint(x: ScreenWidth * 2, y: 0), animated: true)
        }
    }
}

extension WMAddressPicker {
    private func factoryTableView(type: TableViewType, cellIdentifier: String) -> UITableView {
        let tb = UITableView(frame: tbFrame, style: UITableView.Style.plain)
        tb.register(UINib.init(nibName: "WMAddressCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        if #available(iOS 11.0, *) { tb.contentInsetAdjustmentBehavior = .never }
        else { self.automaticallyAdjustsScrollViewInsets = false }
        tb.separatorStyle = UITableViewCell.SeparatorStyle.none
        tb.tableHeaderView = UIView()
        tb.tableFooterView = UIView()
        tb.tag = type.rawValue
        tb.dataSource = self
        tb.delegate = self
        tb.rowHeight = 44.0
        var frame = tb.frame
        switch type {
        case .province: frame.origin.x = 0.0
        case .city: frame.origin.x = ScreenWidth
        case .distrcit: frame.origin.x = ScreenWidth * 2.0
        }
        tb.frame = frame
        return tb
    }
}

extension WMAddressPicker {
    var scrollViewHeight: CGFloat {
        // 适配 iPhoneX 及以上 底部的安全区域，可根据项目中实际 tabBar 的高度适配
//        let mainVC = UIApplication.shared.delegate?.window??.rootViewController as! MainTabbarController
//        return ScreenHeight * 3 / 4 - 70 - (mainVC.tabBar.frame.height - 49)
        return ScreenHeight * 3.0 / 4.0 - 70.0 - (ScreenHeight >= 812.0 ? 34.0 : 0.0)
    }
    var tbFrame: CGRect { return CGRect(x: 0.0, y: 0.0, width: ScreenWidth, height: scrollViewHeight) }
}

extension WMAddressPicker: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  scrollView.tag != 0 { return }
        _ = buttons.map { $0.isSelected = false }
        if scrollView.contentOffset.x == 0.0 { provinceButton.isSelected = true }
        if scrollView.contentOffset.x == ScreenWidth { cityButton.isSelected = true }
        if scrollView.contentOffset.x == ScreenWidth * 2.0 { districtButton.isSelected = true }
    }
}

extension WMAddressPicker {
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.scrollViewHeightConstaint.constant = scrollViewHeight
    }
}
