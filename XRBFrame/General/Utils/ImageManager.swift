//
//  ImageManager.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import Kingfisher

struct ImageManager {    
    static func retrieveImage(with url: String,
                              forceRefresh: Bool = false,
                              queue: DispatchQueue? = nil,
                              completionHandler: ((UIImage?) -> Void)? = nil) {
        
        guard let downloadURL = URL(string: url) else {
            completionHandler?(nil)
            return
        }
        
        var options: KingfisherOptionsInfo = []
        if forceRefresh {
            options.append(.forceRefresh)
        }
        if let queue = queue {
            options.append(.callbackQueue(.dispatch(queue)))
        }
        
        let imageResource = ImageResource(downloadURL: downloadURL)
        KingfisherManager.shared.retrieveImage(with: imageResource, options: options) { result in
            switch result {
            case .success(let value):
                completionHandler?(value.image)
            case .failure(let error):
                completionHandler?(nil)
                print("KingfisherManager gets an image from a given resource error: \(String(describing: error.localizedDescription))")
            }
        }
    }
}
