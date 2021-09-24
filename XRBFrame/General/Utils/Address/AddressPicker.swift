//
//  AddressPicker.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

class AddressPicker: NSObject {
    var selectedAreaCompleted: AreaAction? {
        didSet {
            picker.selectedAreaCompleted = selectedAreaCompleted
        }
    }
    
    private lazy var picker: WMAddressPicker = {
        let nib = UINib(nibName: "WMAddressPicker", bundle: nil)
        let picker = nib.instantiate(withOwner: nil, options: nil).first as! WMAddressPicker
        picker.accuracy = 2
        picker.modalSize = (width: .full, height: .threeQuarters)
        picker.modalPosition = .bottomCenter
        picker.opacity = 0.5
        return picker
    }()
    
    func presented(in vc: UIViewController) {
        vc.presentVC(picker)
    }
}
