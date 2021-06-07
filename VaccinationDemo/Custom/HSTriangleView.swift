//
//  HSTriangleView.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/3.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class HSTriangleView: UIView {
    var color: UIColor = .white
    
    var insets: UIEdgeInsets = .zero
    
    var value: Int = 0
    
    var specialTag: String = ""
    
    var didClickBlock: ((_ sender: HSTriangleView) -> Void)? {
        didSet {
            if didClickBlock != nil {
                setTapHandler()
            } else {
                if tap != nil {
                    removeGestureRecognizer(tap!)
                    tap = nil
                }
            }
        }
    }
    
    private var tap: UITapGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTapHandler() {
        if tap != nil {
            self.removeGestureRecognizer(tap!)
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.addGestureRecognizer(tap!)
    }
    
    @objc private func tapHandler() {
        didClickBlock?(self)
    }
    
    override func draw(_ rect: CGRect) {
        drawTrianglePath(rect: rect)
    }
    
    private func drawTrianglePath(rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: insets.left, y: insets.top))
        path.addLine(to: CGPoint(x: rect.size.width - insets.right, y: insets.top))
        path.addLine(to: CGPoint(x: rect.size.width / 2.0, y: rect.size.height - insets.bottom))
        
        path.close()
        
        color.set()
        path.fill()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
