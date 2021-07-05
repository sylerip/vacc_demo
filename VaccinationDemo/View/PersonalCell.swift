//
//  PersonalCell.swift
//  VaccinationDemo
//
//  Created by Haysen on 2021/4/2.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class PersonalCell: BaseContentCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleView.titleLabel.text = "Personal Information"
        self.titleView.iconView.image = UIImage(named: "icon_personal")
        self.titleView.iconView.snp.updateConstraints { (maker) in
            maker.width.equalTo(HorizontalPixel(40))
            maker.height.equalTo(VerticalPixel(35))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupCenterView() {
        let familyNameTitle = createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427))
        familyNameTitle.text = "Family Name"
        self.centerView.addSubview(familyNameTitle)
        familyNameTitle.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(25))
            maker.top.equalToSuperview().offset(VerticalPixel(25))
        }
//        familyNameCheckBox.isChecked = true
//        familyNameCheckBox.isHidden = true
        self.centerView.addSubview(familyNameCheckBox)
        familyNameCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(familyNameTitle.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(familyNameTitle)
            maker.width.height.equalTo(30)
        }
        
        
        self.centerView.addSubview(familyNameLabel)
        familyNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(familyNameTitle)
            maker.top.equalTo(familyNameTitle.snp.bottom).offset(VerticalPixel(15))
            maker.right.equalTo(self.centerView.snp.centerX)
        }
        
        let givenNameTitle = createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427))
        givenNameTitle.text = "Given Name"
        self.centerView.addSubview(givenNameTitle)
        givenNameTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.centerView.snp.centerX).offset(HorizontalPixel(25))
            maker.top.equalTo(familyNameTitle)
        }
        
        self.centerView.addSubview(givenNameCheckBox)
        givenNameCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(givenNameTitle.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(givenNameTitle)
            maker.width.height.equalTo(30)
        }
        
        self.centerView.addSubview(givenNameLabel)
        givenNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(givenNameTitle)
            maker.top.equalTo(familyNameLabel)
            maker.right.equalToSuperview().offset(HorizontalPixel(-5))
            maker.bottom.equalToSuperview().offset(VerticalPixel(-10))
        }
    }
    
    override func setupBottomView() {
        let docTypeTitle = createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427))
        docTypeTitle.text = "Document Type"
        self.bottomView.addSubview(docTypeTitle)
        docTypeTitle.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(25))
            maker.top.equalToSuperview().offset(VerticalPixel(15))
        }
        
        self.bottomView.addSubview(documentTypeCheckBox)
        documentTypeCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(docTypeTitle.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(docTypeTitle)
            maker.width.height.equalTo(30)
        }
        
        self.bottomView.addSubview(documentTypeLabel)
        documentTypeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(docTypeTitle)
            maker.top.equalTo(docTypeTitle.snp.bottom).offset(VerticalPixel(15))
            maker.right.equalToSuperview().offset(HorizontalPixel(-25))
        }
        
        let docNoTitle = createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427))
        docNoTitle.text = "Document No."
        self.bottomView.addSubview(docNoTitle)
        docNoTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(docTypeTitle)
            maker.top.equalTo(documentTypeLabel.snp.bottom).offset(VerticalPixel(20))
        }
        
        self.bottomView.addSubview(documentNoCheckBox)
        documentNoCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(docNoTitle.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(docNoTitle)
            maker.width.height.equalTo(30)
        }
        
        self.bottomView.addSubview(documentNoLabel)
        documentNoLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(docNoTitle)
            maker.top.equalTo(docNoTitle.snp.bottom).offset(VerticalPixel(15))
            maker.right.equalToSuperview().offset(HorizontalPixel(-25))
//            maker.bottom.equalToSuperview().offset(VerticalPixel(-25))
        }
        
        let docphoto = createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427))
        docphoto.text = "ID Photo:"
        self.bottomView.addSubview(docphoto)
        docphoto.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.centerView.snp.centerX).offset(VerticalPixel(15))
            maker.top.equalToSuperview().offset(VerticalPixel(15))
        }
        
//        self.bottomView.addSubview(docPhotoCheckBox)
//        docPhotoCheckBox.snp.makeConstraints { (maker) in
//            maker.left.equalTo(docphoto.snp.right).offset(HorizontalPixel(3))
//            maker.centerY.equalTo(docphoto)
//            maker.width.height.equalTo(30)
//        }
        
        self.bottomView.addSubview(docPhotoView)
        docPhotoView.snp.makeConstraints { (maker) in
            maker.left.equalTo(docphoto)
            maker.top.equalTo(docphoto.snp_bottom).offset(HorizontalPixel(10))
            maker.height.equalTo(120)
            maker.width.equalTo(90)
        }
        
        
        let passNoTitle = createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427))
        passNoTitle.text = "Passport No."
        self.bottomView.addSubview(passNoTitle)
        passNoTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(docNoTitle)
            maker.top.equalTo(documentNoLabel.snp.bottom).offset(VerticalPixel(20))
        }
        
        self.bottomView.addSubview(passNoCheckBox)
        passNoCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(passNoTitle.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(passNoTitle)
            maker.width.height.equalTo(30)
        }
        
        self.bottomView.addSubview(passNoLabel)
        passNoLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(passNoTitle)
            maker.top.equalTo(passNoTitle.snp.bottom).offset(VerticalPixel(15))
            maker.right.equalToSuperview().offset(HorizontalPixel(-25))
//            maker.bottom.equalToSuperview().offset(VerticalPixel(-25))
        }
        
        
        let mpNoTitle = createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427))
        mpNoTitle.text = "Mainland Travel Permit No."
        self.bottomView.addSubview(mpNoTitle)
        mpNoTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(passNoTitle)
            maker.top.equalTo(passNoLabel.snp.bottom).offset(VerticalPixel(20))
        }
        
        self.bottomView.addSubview(mpNoCheckBox)
        mpNoCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(mpNoTitle.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(mpNoTitle)
            maker.width.height.equalTo(30)
        }
        
        self.bottomView.addSubview(mpNoLabel)
        mpNoLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(mpNoTitle)
            maker.top.equalTo(mpNoTitle.snp.bottom).offset(VerticalPixel(15))
            maker.right.equalToSuperview().offset(HorizontalPixel(-25))
            maker.bottom.equalToSuperview().offset(VerticalPixel(-25))
        }
    }
    
    private(set) lazy var familyNameLabel: HSLabel = {
        return createLabel(fontSize: 16, textColor: .black)
    }()
    
    private(set) lazy var givenNameLabel: HSLabel = {
        return createLabel(fontSize: 16, textColor: .black, numberOfLines: 0)
    }()
    
    private(set) lazy var documentTypeLabel: HSLabel = {
        return createLabel(fontSize: 16, textColor: .black, numberOfLines: 0)
    }()
    
    private(set) lazy var documentNoLabel: HSLabel = {
        return createLabel(fontSize: 16, textColor: .black)
    }()
    
    private(set) lazy var familyNameCheckBox: HSCheckBox = {
        return createCheckBox()
    }()
    
    private(set) lazy var givenNameCheckBox: HSCheckBox = {
        return createCheckBox()
    }()
    
    private(set) lazy var documentTypeCheckBox: HSCheckBox = {
        return createCheckBox()
    }()
    
    private(set) lazy var documentNoCheckBox: HSCheckBox = {
        return createCheckBox()
    }()
    private(set) lazy var passNoLabel: HSLabel = {
        return createLabel(fontSize: 16, textColor: .black)
    }()
    
    private(set) lazy var mpNoLabel: HSLabel = {
        return createLabel(fontSize: 16, textColor: .black)
    }()
    private(set) lazy var passNoCheckBox: HSCheckBox = {
        return createCheckBox()
    }()
    private(set) lazy var mpNoCheckBox: HSCheckBox = {
        return createCheckBox()
    }()
    private(set) lazy var docPhotoCheckBox: HSCheckBox = {
        return createCheckBox()
    }()
    private(set) lazy var docPhotoView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "user.png")?.imageWithInsets(insetDimen: 10.0)
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
//        iv.layer.masksToBounds = true
//        iv.layer.cornerRadius = 20
//        iv.layer.borderWidth = 5
//        iv.layer.borderColor = UIColor.gray.cgColor
//        let tap = UITapGestureRecognizer(target: self, action: #selector(templateTappedRes))
//        iv.addGestureRecognizer(tap)
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
