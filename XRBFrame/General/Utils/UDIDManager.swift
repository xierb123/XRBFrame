//
//  UDIDManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import KeychainAccess

struct UDIDManager {
    private static let udidService: String = App.bundleId
    private static let udidKey: String = "hicon_multiscreen_udid"

    static func getUDID() -> String {
        let keychain = Keychain(service: udidService)
        if let udid = keychain[udidKey] {
            return udid
        } else {
            let udid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            keychain[udidKey] = udid
            return udid
        }
    }
}
