//
//  UIFont+Extension.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/3/31.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

extension UIFont {
    class func hs_systemFont(size: CGFloat, isBold: Bool = false) -> UIFont {
        if isBold {
            return UIFont.boldSystemFont(ofSize: size * BaseWidthScale)
        }
        return UIFont.systemFont(ofSize: size * BaseWidthScale)
    }
}
