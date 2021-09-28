//
//  CollectionCellViewModel.swift
//  QingkCloud_Swift
//
//  Created by gaoyuan on 2019/9/5.
//

import Foundation

public struct CellViewModel {
    
    public var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    public var showBottomLine: Bool = false
    public var showTopLine: Bool    = false
    
    public var isFirst: Bool = false
    public var isLast: Bool  = false
    
    public var data: Any?
    public var extensionData: Any?
    
    public var itemIdentifier: String   = ""
    public var itemSize: CGSize         = CGSize.zero
    public var autoLayout: Bool         = false
    public init() {
        
    }
}
