//
//  CustomCollectionReusableView.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class CustomCollectionReusableView: UICollectionReusableView {
    override class var layerClass: AnyClass {
        return CustomLayer.self
    }
}
