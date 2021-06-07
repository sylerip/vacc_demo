//
//  UIColor+Extension.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/3/31.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

extension UIColor {
    /// RGB颜色
    ///
    /// - Parameters:
    ///   - red: R
    ///   - green: G
    ///   - blue: B
    ///   - alpha: A
    convenience init(red:Int, green:Int, blue:Int, alpha:CGFloat = 1.0) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    
    /// 16进制颜色
    ///
    /// - Parameters:
    ///   - rgb: RGB Int值
    ///   - alpha: 透明度
    convenience init(hex rgb:Int, alpha:CGFloat = 1.0) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF, alpha: alpha)
    }
}
