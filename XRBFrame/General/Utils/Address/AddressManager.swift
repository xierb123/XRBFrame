//
//  AddressManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

struct AddressManager {
    static private var lastUpdateDate: Date? {
        set {
            let key = "provinces_update_date"
            UserDefaults.standard.set(newValue, forKey: key)
        }
        get {
            let key = "provinces_update_date"
            let date = UserDefaults.standard.value(forKey: key) as? Date
            return date
        }
    }
    
    static var provinces: [Province]? {
        let table = DatabaseTable<Province>(name: .provinces)
        let provinces = table.getObjects()
        return provinces.isEmpty ? nil : provinces
    }

    /// 获取地理区域
    static func requestGeographicArea() {
        func requestAreaList() {
            NetworkManager.request(AddressAPI.list, successClosure: { (response) in
                DispatchQueue.global().async {
                    if let provinces = response.mapArray(Province.self) {
                        let table = DatabaseTable<Province>(name: .provinces)
                        table.delete()
                        table.insert(objects: provinces)
                        lastUpdateDate = Date()
                    }
                }
            })
        }
        
        if let date = lastUpdateDate {
            if Date().timeIntervalSince(date) >= 7 * 24 * 60 * 60 {
                requestAreaList()
            }
        } else {
            requestAreaList()
        }
    }
}
