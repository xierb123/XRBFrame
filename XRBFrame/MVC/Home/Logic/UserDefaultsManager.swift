//
//  UserDefaultsManager.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/10/8.
//

import Foundation

enum UserDefaultsEnum: String {
    case name
    case age
}

extension UserDefaultsEnum: UserDefaultsProtocol {
    var key: String {
        return "xrb_\(rawValue)"
    }
    
    var userDefaults: UserDefaults {
        return UserDefaults(suiteName: "xrb_") ?? UserDefaults.standard
    }
}
