//
//  ImageDefault.swift
//  HiconMultiScreen
//
//  Created by devchena on 2021/7/7.
//

import Foundation

@propertyWrapper
struct ImageDefault {
    let key: String
    
    var wrappedValue: UIImage? {
        set {
            let imageData = newValue?.pngData() ?? newValue?.jpegData(compressionQuality: 1.0)
            UserDefaults.standard.setValue(imageData, forKey: key)
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            return UIImage(data: data)
        }
    }
}
