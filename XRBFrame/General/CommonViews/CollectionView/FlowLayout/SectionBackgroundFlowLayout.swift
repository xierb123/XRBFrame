//
//  SectionBackgroundFlowLayout.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

protocol SectionBackgroundDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAtIndex section: Int) -> UIColor
}

extension SectionBackgroundDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAtIndex section: Int) -> UIColor {
        return .clear
    }
}

private class SectionBackgroundLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor: UIColor = .clear
}

private class SectionBackgroundReusableView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? SectionBackgroundLayoutAttributes else {
            return
        }
        backgroundColor = attributes.backgroundColor
    }
}
    
class SectionBackgroundFlowLayout: UICollectionViewFlowLayout {
    private let kSectionBackgroundKind = "SectionBackgroundReusableView"
    private var decorationViewAttributes: [UICollectionViewLayoutAttributes] = []

    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        register(SectionBackgroundReusableView.self, forDecorationViewOfKind: kSectionBackgroundKind)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        guard let delegate = collectionView.delegate as? SectionBackgroundDelegateFlowLayout else {
            return
        }
        
        decorationViewAttributes.removeAll()
        
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            guard numberOfItems > 0,
                let firstItem = layoutAttributesForItem(at: IndexPath(row: 0, section: section)),
                let lastItem = layoutAttributesForItem(at: IndexPath(row: numberOfItems - 1, section: section)) else {
                continue
            }
            
            var sectionInset = self.sectionInset
            if let inset = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x = 0
            sectionFrame.origin.y -= sectionInset.top
            
            if scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = collectionView.frame.height
            } else {
                sectionFrame.size.width += collectionView.frame.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
            
            let attributes = SectionBackgroundLayoutAttributes(forDecorationViewOfKind: kSectionBackgroundKind, with: IndexPath(row: 0, section: section))
            attributes.frame = sectionFrame
            attributes.zIndex = -1
            attributes.backgroundColor = delegate.collectionView(collectionView, layout: self, backgroundColorForSectionAtIndex: section)
            decorationViewAttributes.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)
        attributes?.append(contentsOf: decorationViewAttributes.filter({ (attribute) -> Bool in
            return rect.intersects(attribute.frame)
        }))
        return attributes
    }
}
