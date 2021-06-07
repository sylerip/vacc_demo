//
//  HSCheckBox.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/3.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class HSCheckBox: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(box)
        addSubview(checkedView)
        
        box.layer.cornerRadius = 10
        box.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(20)
        }
        
        checkedView.isHidden = true
        checkedView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        
        self.addTarget(self, action: #selector(tapHandler), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapHandler() {
        isChecked = !isChecked
        
        didClickBlock?(self)
    }
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                box.backgroundColor = UIColor(hex: 0x256ba9)
                checkedView.isHidden = false
            } else {
                box.backgroundColor = .white
                checkedView.isHidden = true
            }
        }
    }
    
    var specialTag: String = ""
    
    var didClickBlock: ((_ sender: HSCheckBox) -> Void)?
    
    private lazy var box: UIView = {
        let v = UIView()
        v.layer.borderWidth = 3
        v.layer.borderColor = UIColor(hex: 0x256ba9).cgColor
        v.backgroundColor = .white
        v.isUserInteractionEnabled = false
        return v
    }()
    
    private lazy var checkedView: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = .white
        lbl.text = "✓"
        return lbl
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
