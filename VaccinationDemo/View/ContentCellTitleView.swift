//
//  ContentCellTitleView.swift
//  VaccinationDemo
//
//  Created by Haysen on 2021/4/2.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class ContentCellTitleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(iconView)
        addSubview(line)
        
        iconView.snp.makeConstraints { (maker) in
            maker.left.centerY.equalToSuperview()
            maker.width.height.equalTo(VerticalPixel(60))
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(iconView.snp.right)
            maker.centerY.equalToSuperview()
        }
        
        line.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.hs_systemFont(size: 20, isBold: true)
        lbl.textColor = UIColor.init(hex: 0x256ba9)
        return lbl
    }()
    
    private(set) lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var line: UIView = {
        let l = UIView()
        l.backgroundColor = UIColor.init(hex: 0x03d9c5)
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
