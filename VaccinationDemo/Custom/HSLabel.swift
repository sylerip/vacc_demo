//
//  HSLabel.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/3.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class HSLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String? {
        get {
            return hs_text
        }
        set {
            if !setSecureTextFlag {
                hs_text = newValue
            }
            
            if !isSecureText || setSecureTextFlag {
                super.text = newValue
            }
        }
    }
    
    var isSecureText: Bool = false {
        didSet {
            if isSecureText {
                setSecureTextFlag = true
                
                text = "*****"
                
                setSecureTextFlag = false
            } else {
                text = hs_text
            }
        }
    }
    
    var specialTag: String = ""
    
    private(set) var hs_text: String?
    
    private var setSecureTextFlag: Bool = false
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
