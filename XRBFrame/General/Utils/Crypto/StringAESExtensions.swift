//
//  StringAESExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import CryptoSwift

extension String {
    /// AES+CBC加密
    func aesEncryption(needURLEncoded: Bool = false) -> String {
        let string = self
        let secretKey = "haikanwangluo666".bytes
        let key = secretKey
        let iv = secretKey
        
        guard let aes = try? AES(key: key, blockMode: CBC(iv: iv), padding: Padding.pkcs7) else {
            return string
        }
        guard let encrypted = try? aes.encrypt(string.bytes) else {
            return string
        }
        
        // base64 encoded
        let result = Data(encrypted).base64EncodedString()
        if needURLEncoded {
            return result.urlEncoded ?? result
        } else {
            return result
        }
    }
}
