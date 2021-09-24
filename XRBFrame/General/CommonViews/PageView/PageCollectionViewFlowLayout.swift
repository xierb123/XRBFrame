//
//  PageCollectionViewFlowLayout.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class PageCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var offset: CGFloat?

    override func prepare() {
        super.prepare()
        guard let offset = offset else { return }
        collectionView?.contentOffset = CGPoint(x: offset, y: 0)
    }
}
