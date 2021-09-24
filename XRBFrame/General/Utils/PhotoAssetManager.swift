//
//  PhotoAssetManager.swift
//  HKMediaAsset
//
//  Created by user on 2019/1/7.
//  Copyright © 2019 HICON. All rights reserved.
//

import UIKit
import Photos

struct PhotoAssetManager {
    /// 获取相册的访问授权状态
    static func authorizationStatus(_ completionHandler: @escaping (Bool) -> Void) {
        let status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        
        func complete(_ isAllowed: Bool) {
            DispatchQueue.main.safeAsync {
                completionHandler(isAllowed)
            }
        }
        
        switch status {
        case .authorized, .limited:
            complete(true)
        case .denied, .restricted:
            complete(false)
        case PHAuthorizationStatus.notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                    complete(status == .authorized || status == .limited)
                }
            } else {
                PHPhotoLibrary.requestAuthorization({ status in
                    complete(status == .authorized)
                })
            }
        @unknown default:
            complete(false)
        }
    }
    
    /// 提醒开启相册权限
    static func alertToOpenPhotoAlbumPermission() {
        let title = "您没有开启相册权限"
        let message = "请在【设置】-【隐私】-【照片】里打开允许获取照片的权限"
        Alert.show(title: title, message: message, actions: [
            CustomAlertAction(title: "取消", type: .cancel),
            CustomAlertAction(title: "去设置", type: .default, handler: {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
        ])
    }
}
