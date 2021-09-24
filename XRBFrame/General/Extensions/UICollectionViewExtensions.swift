//
//  UICollectionViewExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

extension UICollectionView {
    /// 重新加载数据
    /// 修复重载时的闪烁问题
    func reloadDataWithoutFlicker() {
        let offset = contentOffset
        reloadData()
        collectionViewLayout.invalidateLayout()
        layoutIfNeeded()
        setContentOffset(offset, animated: false)
    }
}
