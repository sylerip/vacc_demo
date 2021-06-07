//
//  ToastView.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/3/31.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class ToastView: UIView {
    
    class func showToast(_ toast: String, duration: TimeInterval = 2, on view: UIView? = nil) {
        ToastView.shared._showToast(toast, duration: duration, on: view)
    }
    
    private static let shared = ToastView()
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _showToast(_ toast: String, duration: TimeInterval, on view: UIView? = nil) {
        var spv = view
        if spv == nil {
            spv = KeyWindow
        }
        
        if spv != nil {
            if toast.isEmpty {
                if toastContentView.superview != nil {
                    self.toastFlags += 1
                    
                    toastContentView.layer.removeAllAnimations()
                    
                    removeToastView()
                }
            } else {
                self.toastFlags += 1
                
                toastContentView.layer.removeAllAnimations()
                
                if toastContentView.superview == nil {
                    let maxWidth = UIScreen.main.bounds.size.width / 1.2
                    
                    spv!.addSubview(toastContentView)
                    toastContentView.snp.makeConstraints { (maker) in
                        maker.center.equalToSuperview()
                        maker.width.lessThanOrEqualTo(maxWidth)
                        maker.height.lessThanOrEqualToSuperview()
                    }
                }
                
                if toastContentBG.superview == nil {
                    toastContentView.addSubview(toastContentBG)
                    toastContentBG.snp.makeConstraints { (maker) in
                        maker.left.top.right.bottom.equalToSuperview()
                    }
                    
                    toastContentView.addSubview(toastLabel)
                    toastLabel.snp.makeConstraints { (maker) in
                        maker.left.equalToSuperview().offset(20)
                        maker.right.equalToSuperview().offset(-20)
                        maker.top.equalToSuperview().offset(12)
                        maker.bottom.equalToSuperview().offset(-12)
                    }
                }
                
                self.toastLabel.text = toast
                
                UIView.animate(withDuration: 0.5) {
                    self.toastContentView.alpha = 1
                }
                
                self.removeToastView(after: duration + 0.5, flags: self.toastFlags)
            }
        }
    }
    
    private var toastFlags: Int = 0
    private func removeToastView(after: TimeInterval, flags: Int) {
        if after > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + after) {
                if flags == self.toastFlags {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.toastContentView.alpha = 0
                    }, completion: { (finished) in
                        if flags == self.toastFlags {
                            self.removeToastView()
                        }
                    })
                }
            }
        }
    }
    private func removeToastView() {
        if self.toastContentView.superview != nil {
            self.toastContentView.removeFromSuperview()
        }
    }
    
    
    
    private lazy var toastContentView: UIView = {
        let v = UIView()
        v.alpha = 0
        return v
    }()
    
    private lazy var toastContentBG: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.init(white: 0, alpha: 0.75)
        v.layer.cornerRadius = 5
        return v
    }()
    
    private lazy var toastLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.hs_systemFont(size: 15.0)
        l.textColor = UIColor.white
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
