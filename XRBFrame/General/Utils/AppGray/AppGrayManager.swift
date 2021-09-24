//
//  AppGrayManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

struct AppGrayManager {
    static func setGrayMode(_ isGray: Bool) {
        if isGray {
            UIApplication.shared.delegate?.window??.changeAppGray("colorSaturate", andClass: "CAFilter", andKey: "inputAmount")
        } else {
            UIApplication.shared.delegate?.window??.layer.filters?.removeAll()
        }
    }
}
