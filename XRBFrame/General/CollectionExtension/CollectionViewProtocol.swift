//
//  CollectionViewProtocol.swift
//  QingkCloud_Swift
//
//  Created by gaoyuan on 2019/9/5.
//

import UIKit

public class CollectionViewProtocol: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public var data: Array<CollectionSectionViewModel>?
    
    //  MARK: - UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?[section].itemViewModels?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var itemIdentifier = (data?[indexPath.section])!.itemIdentifier
        if (data?[indexPath.section])!.needMutableIdentifier {
            let model : CellViewModel  = data?[indexPath.section].itemViewModels?[indexPath.row] as! CellViewModel
            itemIdentifier = model.itemIdentifier
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier, for: indexPath) as? BindData {
        
            if let json = data?[indexPath.section].itemViewModels?[indexPath.row] {
                cell.bindData(json)
            }
            
            return cell as! UICollectionViewCell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            
            if let identifier = data?[indexPath.section].footerIdentifier,!identifier.isEmpty {
                
                if let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? BindData, let json = data?[indexPath.section].footerViewModel {
                    cell.bindData(json)
                    return cell as! UICollectionReusableView
                }
                
            }
            
        case UICollectionView.elementKindSectionHeader:
            
            if let identifier = data?[indexPath.section].headerIdentifier,!identifier.isEmpty {
                
                if let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? BindData, let json = data?[indexPath.section].headerViewModel {
                    cell.bindData(json)
                    return cell as! UICollectionReusableView
                }
                
            }
            
        default: break
            
        }
        
        return UICollectionReusableView()
    }
    
    //  MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let data = data?[indexPath.section].itemViewModels?[indexPath.row],let cell = collectionView.cellForItem(at: indexPath) {
            let name = String(describing: type(of: cell))
            cell.routerEvent(Comment(event: .clicked(data), type: name))
        }
        
    }
    
    //  MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //多类型cell情况
        if let needMutableIdentifier = data?[indexPath.section].needMutableIdentifier,needMutableIdentifier {
            
            if (data?[indexPath.section].itemViewModels?[indexPath.row]) != nil {
                let cellModel  = data?[indexPath.section].itemViewModels?[indexPath.row] as! CellViewModel
                if  cellModel.autoLayout {
                    return cellSize(of: collectionView, at: indexPath)
                }else {
                    return cellModel.itemSize
                }
            }else {
                return CGSize.zero
            }
            
        }else{//单一类型cell情况
            if let autoLayout = data?[indexPath.section].autoLayout, autoLayout {
                    return cellSize(of: collectionView, at: indexPath)
                }else {
                    return data?[indexPath.section].itemSize ?? CGSize.zero
            }
        }
        

        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return data?[section].sectionInset ?? UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return data?[section].minimumLineSpacing ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return data?[section].minimumInteritemSpacing ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return data?[section].headerSize ?? CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return data?[section].footerSize ?? CGSize.zero
    }
    
    public func cellSize(of collectionView: UICollectionView, at indexPath: IndexPath) -> CGSize {
        
        if let viewModel = data?[indexPath.section] {
             
            var size = viewModel.itemSize
            var itemIdentifier = viewModel.itemIdentifier
            
            if viewModel.needMutableIdentifier {
                let cellModel  = viewModel.itemViewModels?[indexPath.row] as! CellViewModel
                itemIdentifier = cellModel.itemIdentifier
                size = cellModel.itemSize
            }
            if let cellType = NSObject.swiftClassFromString(itemIdentifier) as? UICollectionViewCell.Type {
                let cell = cellType.init()
                
                if let cellBinding = cell as? BindData, let json = data?[indexPath.section].itemViewModels?[indexPath.row] {
                    cellBinding.bindData(json)
                }
                           
                if size.height == 0 {
                               
                    let widthFenceConstraint = NSLayoutConstraint(item: cell.contentView ,
                                                             attribute: NSLayoutConstraint.Attribute.width,
                                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                                                toItem: nil,
                                                             attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                            multiplier: 1.0,
                                                              constant: size.width)
                               
                    cell.contentView.addConstraint(widthFenceConstraint)
                    size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                               
                }else {
                               
                    let widthFenceConstraint = NSLayoutConstraint(item: cell.contentView ,
                                                             attribute: NSLayoutConstraint.Attribute.height,
                                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                                                toItem: nil,
                                                             attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                            multiplier: 1.0,
                                                              constant: size.height)
                               
                    cell.contentView.addConstraint(widthFenceConstraint)
                    size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                               
                }
            }
            
            return size
        }
        
        return CGSize.zero
    }
    
}
