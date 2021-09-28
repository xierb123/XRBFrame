//
//  CollectionSectionViewModel.swift
//  QingkCloud_Swift
//
//  Created by gaoyuan on 2019/9/5.
//

import Foundation

public struct CollectionSectionViewModel {
    
    public var type: String
    //间距
    public var minimumLineSpacing: CGFloat      = 0
    public var minimumInteritemSpacing: CGFloat = 0
    public var sectionInset: UIEdgeInsets       = UIEdgeInsets.zero
    //相同cell是否自适应高度
    public var autoLayout: Bool                 = false
    //是否可变cell,如果为true-CellViewModel中必须设置itemIdentifier
    public var needMutableIdentifier: Bool      = false
    //cell相关属性
    public var itemIdentifier: String   = ""
    public var itemSize: CGSize         = CGSize.zero
    public var itemViewModels: Array<Any>?
    //header相关属性
    public var headerIdentifier: String = ""
    public var headerSize: CGSize       = CGSize.zero
    public var headerViewModel: Any?
    //footer相关属性
    public var footerIdentifier: String = ""
    public var footerSize: CGSize       = CGSize.zero
    public var footerViewModel: Any?
    
    public init(type: String) {
        self.type = type
    }
    
}
