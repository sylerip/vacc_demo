//
//  HSShareButton.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/4.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class HSShareButton: UIView {
    var didClickBlock: (() -> Void)? {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.frame.size.height > 0 {
            setupShadow()
            
            contentView.layer.cornerRadius = self.frame.size.height / 2.0
        }
    }
    
    private func setupShadow() {
        if shadow == nil {
            var shadow = HSShadow()
            shadow.color = UIColor.init(white: 0, alpha: 0.2)
            shadow.opacity = 1
            shadow.offset = CGSize(width: 0, height: 7)
            shadow.radius = 7
            shadow.cornerRadius = self.frame.size.height / 2.0
            
            hs_setupShadow(shadow)
            
            self.shadow = shadow
        }
    }
    
    private func setTapHandler() {
        if tap != nil {
            self.removeGestureRecognizer(tap!)
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.addGestureRecognizer(tap!)
    }
    
    @objc private func tapHandler() {
        didClickBlock?()
    }
    
    private var shadow: HSShadow?
    
    private var tap: UITapGestureRecognizer?
    
    private lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: 0x256ba9)
        
        let layoutView = UIView()
        layoutView.addSubview(titleLabel)
        layoutView.addSubview(iconView)
        
        iconView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalToSuperview()
            maker.width.equalTo(iconView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(iconView.snp.right)
            maker.centerY.right.equalToSuperview()
        }
        
        v.addSubview(layoutView)
        layoutView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.left.equalToSuperview().offset(HorizontalPixel(30))
            maker.right.equalToSuperview().offset(HorizontalPixel(-30))
            maker.top.equalToSuperview().offset(VerticalPixel(10))
            maker.bottom.equalToSuperview().offset(VerticalPixel(-10))
        }
        
        return v
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.hs_systemFont(size: 22, isBold: true)
        lbl.textColor = .white
        lbl.text = "SHARE"
        return lbl
    }()
    
    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "shareIcon")
        return iv
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
