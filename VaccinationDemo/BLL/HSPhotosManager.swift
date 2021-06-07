//
//  HSPhotosManager.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/5.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit
import Photos

class HSPhotosManager {
    class func requestAccessPhotoLibrary(isAlert: Bool = false, callback: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (ret) in
                DispatchQueue.main.async {
                    if ret == .authorized {
                        callback(true)
                    } else {
                        callback(false)
                    }
                }
            }
        } else {
            if status == .authorized {
                callback(true)
            } else {
                if isAlert {
                    showPhotoLibraryAuthorizationAlert()
                }
                callback(false)
            }
        }
    }
    private class func showPhotoLibraryAuthorizationAlert() {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            let alert = UIAlertController.init(title: nil, message: "Please allow App to access your album", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    ///保存图片到相册
    class func saveImage(_ image: UIImage, completed: ((Bool) -> Void)? = nil) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (ret) in
                if ret != .authorized {
                    DispatchQueue.main.async {
                        completed?(false)
                    }
                    return
                }
                
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        PHAssetCreationRequest.creationRequestForAsset(from: image)
                        
                        DispatchQueue.main.async {
                            completed?(true)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completed?(false)
                    }
                }
            }
        case .authorized:
            do {
                try PHPhotoLibrary.shared().performChangesAndWait {
                    PHAssetCreationRequest.creationRequestForAsset(from: image)
                    
                    DispatchQueue.main.async {
                        completed?(true)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completed?(false)
                }
            }
        default:
            DispatchQueue.main.async {
                completed?(false)
            }
        }
    }
}
