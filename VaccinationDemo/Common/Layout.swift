//
//  Layout.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/3/31.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

let SCREEN_SCALE = UIScreen.main.scale
let SCREEN_WIDTH = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
let SCREEN_HEIGHT = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
let SCREEN_BOUNDS = UIScreen.main.bounds

let SafeAreaInsets = safeAreaInsets

fileprivate var safeAreaInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
    }
    return .zero
}

fileprivate func _IS_iPhoneX() -> Bool {
    var ret = true
    
    switch SCREEN_HEIGHT {
    case 480.0, 568.0, 667.0, 736.0:
        ret = false
    default:
        if IS_iPad {
            ret = false
        }
    }
    
    return ret
}

let IS_iPad = (UI_USER_INTERFACE_IDIOM() == .pad)
let IS_iPhoneX = _IS_iPhoneX()

fileprivate func _BaseWidthScale() -> CGFloat {
    if IS_iPhoneX {
        return SCREEN_WIDTH / 414.0
    }
    return SCREEN_WIDTH / 414.0
}

fileprivate func _BaseHeightScale() -> CGFloat {
    if IS_iPhoneX {
        //iPhone 11 Pro Max
        return SCREEN_HEIGHT / 896.0
    }
    //iPhone 8 Plus
    return SCREEN_HEIGHT / 736.0
}

let BaseWidthScale = _BaseWidthScale()
let BaseHeightScale = _BaseHeightScale()

func HorizontalPixel(_ pixel: CGFloat) -> CGFloat {
    return pixel * BaseWidthScale
}

func VerticalPixel(_ pixel: CGFloat) -> CGFloat {
    return pixel * BaseHeightScale
}

