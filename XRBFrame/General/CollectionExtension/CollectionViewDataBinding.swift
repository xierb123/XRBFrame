//
//  CollectionViewDataBinding.swift
//  QingkCloud_Swift
//
//  Created by gaoyuan on 2019/9/5.
//

import UIKit

public protocol BindData {
    func bindData(_ data: Any?)
}

public extension NSObject {
    // create a static method to get a swift class for a string name
    class func swiftClassFromString(_ className: String) -> AnyClass! {
        // get the project name
        if  let appName: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String? {
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
            let classStringName = "\(appName!).\(className)"
            // return the class!
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}

public extension UICollectionView {
    
    func registerClass(_ sectionViewModels: Array<CollectionSectionViewModel>) {
        
        for sectionViewModel in sectionViewModels {
            
            if sectionViewModel.needMutableIdentifier {//多类型cell,遍历cell模型中itemIdentifier并注册
                if let cellArr : Array<CellViewModel>  = sectionViewModel.itemViewModels as? Array<CellViewModel> {
                    for cellModel in cellArr {
                        if let itemCell = NSObject.swiftClassFromString(cellModel.itemIdentifier) as? UICollectionViewCell.Type {
                            self.register(itemCell, forCellWithReuseIdentifier: cellModel.itemIdentifier)
                        }
                    }
                }
               
            }else{
                if let itemCell = NSObject.swiftClassFromString(sectionViewModel.itemIdentifier) as? UICollectionViewCell.Type {
                    self.register(itemCell, forCellWithReuseIdentifier: sectionViewModel.itemIdentifier)
                }
            }
            
            if !sectionViewModel.headerIdentifier.isEmpty,let headerCell = NSObject.swiftClassFromString(sectionViewModel.headerIdentifier) as? UICollectionReusableView.Type {
                self.register(headerCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionViewModel.headerIdentifier)
            }
            
            if !sectionViewModel.footerIdentifier.isEmpty,let footerCell = NSObject.swiftClassFromString(sectionViewModel.footerIdentifier) as? UICollectionReusableView.Type {
                self.register(footerCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: sectionViewModel.footerIdentifier)
            }
            
        }
        
    }
    
    func bindData(_ data: Array<CollectionSectionViewModel>) -> CollectionViewProtocol {
        
        registerClass(data)
        
        let collectionViewProtocol = CollectionViewProtocol()
        collectionViewProtocol.data = data
        
        self.delegate   = collectionViewProtocol
        self.dataSource = collectionViewProtocol
        
        UIView.performWithoutAnimation {
            self.reloadData()
        }
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        
        return collectionViewProtocol
    }
    
}
