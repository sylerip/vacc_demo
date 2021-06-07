//
//  BaseContentCell.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/1.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

class BaseContentCell: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupShadow()
        
        baseSetupUI()
    }
    
    private func setupShadow() {
        var shadow = HSShadow()
        shadow.color = UIColor.init(white: 0, alpha: 0.1)
        shadow.opacity = 1
        shadow.offset = CGSize(width: 4, height: 4)
        shadow.radius = 10
        shadow.cornerRadius = 20
        hs_setupShadow(shadow)
    }
    
    private func baseSetupUI() {
        backgroundColor = .white
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalToSuperview()
        }
        
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(18))
            maker.right.equalToSuperview().offset(HorizontalPixel(-18))
            maker.top.equalToSuperview()
            maker.height.equalTo(VerticalPixel(64))
        }
        
        contentView.addSubview(centerView)
        centerView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(titleView.snp.bottom)
            maker.height.greaterThanOrEqualTo(1)
        }
        
        contentView.addSubview(showAllView)
        showAllView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(centerView.snp.bottom)
        }
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(showAllView.snp.bottom)
            maker.height.greaterThanOrEqualTo(1)
        }
        
        setupCenterView()
        
        setupBottomView()
    }
    
    func setupCenterView() {
        
    }
    
    func setupBottomView() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabel(fontSize: CGFloat, textColor: UIColor, isBold: Bool = false, numberOfLines: Int = 1) -> HSLabel {
        let lbl = HSLabel()
        lbl.font = UIFont.hs_systemFont(size: fontSize, isBold: isBold)
        lbl.textColor = textColor
        lbl.numberOfLines = numberOfLines
        
        labelArray.append(lbl)
        return lbl
    }
    
    func createCheckBox(isChecked: Bool = false, isHidden: Bool = true) -> HSCheckBox {
        let checkBox = HSCheckBox()
        checkBox.isChecked = isChecked
        checkBox.isHidden = isHidden
        checkBox.didClickBlock = { [weak self] (sender) in
            guard let `self` = self else { return }
            self.checkBoxDidClick(sender)
        }
        
        checkBoxArray.append(checkBox)
        return checkBox
    }
    
    func createTriangleView(color: UIColor = UIColor(hex: 0x256ba9), insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5), isHidden: Bool = true) -> HSTriangleView {
        let triangleView = HSTriangleView()
        triangleView.color = color
        triangleView.insets = insets
        triangleView.isHidden = isHidden
        triangleView.didClickBlock = { [weak self] sender in
            guard let `self` = self else { return }
            self.triangleViewDidClick(sender)
        }
        
        dateSettingsArray.append(triangleView)
        return triangleView
    }
    
    
    
//    func setLabelSecureText(value: Bool, tag: Int) {
//        for label in self.labelArray {
//            if label.tag == tag {
//                label.isSecureText = value
//                break
//            }
//        }
//    }
    
    func setLabelSecureText(value: Bool, tag: String) {
        for label in self.labelArray {
            if label.specialTag == tag {
                label.isSecureText = value
                break
            }
        }
    }
    
    func setLabelDateText(_ text: String, tag: String) {
        for label in self.labelArray {
            if label.specialTag == tag {
                label.text = text
                break
            }
        }
    }
    
    
    
    ///checkBox点击事件
    func checkBoxDidClick(_ sender: HSCheckBox) {
        setLabelSecureText(value: !sender.isChecked, tag: sender.specialTag)
        
        checkBoxDidClickBlock?(sender)
    }
    
    ///triangleView点击事件
    func triangleViewDidClick(_ sender: HSTriangleView) {
        dateSettingsDidClickBlock?(sender, self)
    }
    
    @objc func showAllButtonTouchUp() {
        isDidShowAll = !isDidShowAll
        
        showAllRelayout(isShowAll: isDidShowAll)
        
        setArrowButtonSelectState(isDidShowAll)
    }
    
    private func showAllRelayout(isShowAll: Bool) {
        if isShowAll {
            showAllView.snp.remakeConstraints { (maker) in
                maker.left.right.equalToSuperview()
                maker.top.equalTo(centerView.snp.bottom)
            }
            
            bottomView.snp.remakeConstraints { (maker) in
                maker.left.right.equalToSuperview()
                maker.top.equalTo(showAllView.snp.bottom)
                maker.bottom.equalToSuperview()
            }
        } else {
            bottomView.snp.remakeConstraints { (maker) in
                maker.left.right.equalToSuperview()
                maker.top.equalTo(showAllView.snp.bottom)
            }
            
            showAllView.snp.remakeConstraints { (maker) in
                maker.left.right.bottom.equalToSuperview()
                maker.top.equalTo(centerView.snp.bottom)
            }
        }
    }
    
    private func setArrowButtonSelectState(_ state: Bool) {
        showAllArrow.isSelected = state
    }
    
    
    
    var checkBoxDidClickBlock: ((_ sender: HSCheckBox) -> Void)?
    
    var dateSettingsDidClickBlock: ((_ sender: HSTriangleView, _ cell: BaseContentCell) -> Void)?
    
    private(set) var isDidShowAll = false
    
    var isHideShowAllView: Bool = false {
        didSet {
            if isHideShowAllView {
                showAllView.snp.remakeConstraints { (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(centerView.snp.bottom)
                }
                
                bottomView.snp.remakeConstraints { (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(showAllView.snp.bottom)
                    maker.height.greaterThanOrEqualTo(1)
                }
                
                centerView.snp.remakeConstraints { (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(titleView.snp.bottom)
                    maker.height.greaterThanOrEqualTo(1)
                    maker.bottom.equalToSuperview()
                }
            } else {
                centerView.snp.remakeConstraints { (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(titleView.snp.bottom)
                    maker.height.greaterThanOrEqualTo(1)
                }
                
                showAllRelayout(isShowAll: isDidShowAll)
            }
        }
    }
    
    var isCheckState: Bool = false {
        didSet {
            for box in checkBoxArray {
                box.isHidden = !isCheckState
            }
        }
    }
    
    ///label列表
    lazy var labelArray = [HSLabel]()
    
    ///是否分享控件列表
    lazy var checkBoxArray = [HSCheckBox]()
    
    ///日期设置控件列表
    lazy var dateSettingsArray = [HSTriangleView]()
    
    private(set) lazy var contentView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        return v
    }()
    
    private(set) lazy var titleView: ContentCellTitleView = {
        let v = ContentCellTitleView()
        return v
    }()
    
    private(set) lazy var centerView: UIView = {
        let v = UIView()
        return v
    }()
    
    private(set) lazy var showAllView: UIView = {
        let v = UIView()
        
        v.addSubview(showAllArrow)
        v.addSubview(showAllButton)
        
        setArrowButtonSelectState(false)
        showAllArrow.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(HorizontalPixel(-29))
            maker.top.equalToSuperview().offset(VerticalPixel(10))
            maker.bottom.equalToSuperview().offset(VerticalPixel(-10))
            maker.width.height.equalTo(HorizontalPixel(25))
        }
        
        showAllButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(showAllArrow.snp.left)
            maker.centerY.equalTo(showAllArrow)
            maker.height.equalTo(25)
        }
        
        return v
    }()
    private lazy var showAllButton: UIButton = {
        let btn = UIButton.init(type: .system)
        btn.titleLabel?.font = UIFont.hs_systemFont(size: 16)
        btn.setTitle("Show All", for: .normal)
        btn.setTitleColor(UIColor(hex: 0x8e8b8b), for: .normal)
        btn.addTarget(self, action: #selector(showAllButtonTouchUp), for: .touchUpInside)
        return btn
    }()
    private lazy var showAllArrow: UIButton = {
        let btn = UIButton()
        btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.setImage(UIImage(named: "icon_arrow_right"), for: .normal)
        btn.setImage(UIImage(named: "icon_arrow_up"), for: .selected)
        btn.addTarget(self, action: #selector(showAllButtonTouchUp), for: .touchUpInside)
        return btn
    }()
    
    private(set) lazy var bottomView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.init(hex: 0xF5F1F1)
        return v
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
