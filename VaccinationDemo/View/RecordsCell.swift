//
//  RecordsCell.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/3.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

protocol RecordsSubCellDataSource: NSObjectProtocol {
    func createLabel(fontSize: CGFloat, textColor: UIColor, isBold: Bool, numberOfLines: Int) -> HSLabel
    
    func createCheckBox(isChecked: Bool, isHidden: Bool) -> HSCheckBox
    
    func createTriangleView(color: UIColor, insets: UIEdgeInsets, isHidden: Bool) -> HSTriangleView
}

class RecordsSubCell: UIView {
    weak var dataSource: RecordsSubCellDataSource?
    
    init(frame: CGRect = CGRect.zero, dataSource: RecordsSubCellDataSource) {
        super.init(frame: frame)
        
        self.dataSource = dataSource
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(dateLabel)
//        addSubview(dateSettingsView)
        addSubview(vaccinatedDateCheckBox)
        addSubview(doseLabel)
        
        addSubview(lnTitle)
        addSubview(lnLabel)
        addSubview(lnCheckBox)
        
        addSubview(vpTitle)
        addSubview(vpLabel)
        addSubview(vpCheckBox)
        
        addSubview(line)
        
        lnTitle.text = "Lot No."
        vpTitle.text = "Vaccination Premises"
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(25))
            maker.top.equalToSuperview().offset(VerticalPixel(20))
            maker.width.lessThanOrEqualTo(SCREEN_WIDTH * 2.0 / 3.0 - HorizontalPixel(52))
        }
        
//        dateSettingsView.snp.makeConstraints { (maker) in
//            maker.left.equalTo(dateLabel.snp.right).offset(HorizontalPixel(3))
//            maker.centerY.equalTo(dateLabel)
//            maker.width.height.equalTo(30)
//        }
        vaccinatedDateCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(dateLabel)
            maker.width.height.equalTo(30)
        }
        
        doseLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(dateLabel)
            maker.right.equalToSuperview().offset(HorizontalPixel(-25))
        }
        
        lnTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel)
            maker.top.equalTo(dateLabel.snp.bottom).offset(VerticalPixel(15))
        }
        
        lnCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(lnTitle.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(lnTitle)
            maker.width.height.equalTo(30)
        }
        
        lnLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(lnTitle)
            maker.top.equalTo(lnTitle.snp.bottom).offset(VerticalPixel(15))
        }
        
        vpTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(lnTitle)
            maker.top.equalTo(lnLabel.snp.bottom).offset(VerticalPixel(15))
        }
        
        vpCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(vpTitle.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(vpTitle)
            maker.width.height.equalTo(30)
        }
        
        vpLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(vpTitle)
            maker.right.equalToSuperview().offset(HorizontalPixel(-25))
            maker.top.equalTo(vpTitle.snp.bottom).offset(VerticalPixel(15))
        }
        
        line.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(23))
            maker.right.equalToSuperview().offset(HorizontalPixel(-23))
            maker.top.equalTo(vpLabel.snp.bottom).offset(VerticalPixel(15))
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1)
        }
    }
    
    
    
    private(set) lazy var dateLabel: HSLabel = {
        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427), isBold: false, numberOfLines: 0) else {
            return HSLabel()
        }
        return lbl
    }()
    
    private(set) lazy var dateSettingsView: HSTriangleView = {
        guard let tv = dataSource?.createTriangleView(color: UIColor(hex: 0x256ba9), insets: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5), isHidden: true) else {
            return HSTriangleView()
        }
        return tv
    }()
    
    private(set) lazy var doseLabel: HSLabel = {
        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427), isBold: false, numberOfLines: 1) else {
            return HSLabel()
        }
        return lbl
    }()
    
    private lazy var lnTitle: HSLabel = {
        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427), isBold: false, numberOfLines: 1) else {
            return HSLabel()
        }
        return lbl
    }()
    
    private(set) lazy var lnLabel: HSLabel = {
        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: .black, isBold: false, numberOfLines: 1) else {
            return HSLabel()
        }
        return lbl
    }()
    
    private(set) lazy var lnCheckBox: HSCheckBox = {
        guard let cb = dataSource?.createCheckBox(isChecked: false, isHidden: true) else {
            return HSCheckBox()
        }
        return cb
    }()
    
    private lazy var vpTitle: HSLabel = {
        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427), isBold: false, numberOfLines: 1) else {
            return HSLabel()
        }
        return lbl
    }()
    
    private(set) lazy var vpLabel: HSLabel = {
        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: .black, isBold: false, numberOfLines: 0) else {
            return HSLabel()
        }
        return lbl
    }()
    
    private(set) lazy var vpCheckBox: HSCheckBox = {
        guard let cb = dataSource?.createCheckBox(isChecked: false, isHidden: true) else {
            return HSCheckBox()
        }
        return cb
    }()
    
    private(set) lazy var line: UIView = {
        let l = UIView()
        l.backgroundColor = UIColor(hex: 0xb4b1b1)
        return l
    }()
    private(set) lazy var vaccinatedDateCheckBox: HSCheckBox = {

        guard let cb = dataSource?.createCheckBox(isChecked: false, isHidden: true) else {
            return HSCheckBox()
        }
        return cb
//    private(set) lazy var vaccinatedDateCheckBox: HSLabel = {
//        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427), isBold: false, numberOfLines: 1) else {
//            return HSLabel()
//        }
//        return lbl
    }()
}



class RecordsCell: BaseContentCell, RecordsSubCellDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleView.titleLabel.text = "Vaccination Records"
        self.titleView.iconView.image = UIImage(named: "vaccinationIcon")
        self.titleView.iconView.snp.updateConstraints { (maker) in
            maker.left.equalToSuperview().offset(VerticalPixel(-10))
        }
        self.titleView.titleLabel.snp.updateConstraints { (maker) in
            maker.left.equalTo(self.titleView.iconView.snp.right).offset(VerticalPixel(-10))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupCenterView() {
        let titleLabel = createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427))
        titleLabel.text = "Vaccine Name"
        self.centerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(25))
            maker.top.equalToSuperview().offset(VerticalPixel(25))
        }
        
        self.centerView.addSubview(vaccinatedCheckBox)
        vaccinatedCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(titleLabel)
            maker.width.height.equalTo(30)
        }
        
        self.centerView.addSubview(vaccinatedLabel)
        vaccinatedLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel)
            maker.top.equalTo(titleLabel.snp.bottom).offset(VerticalPixel(15))
            maker.right.equalToSuperview().offset(HorizontalPixel(-25))
            maker.bottom.equalToSuperview().offset(VerticalPixel(-10))
        }
    }
    
    override func setupBottomView() {
        self.bottomView.addSubview(d1SubCell)
        self.bottomView.addSubview(d2SubCell)
        
        d1SubCell.doseLabel.text = "Dose: D1"
        d2SubCell.doseLabel.text = "Dose: D2"
        
        
        d1SubCell.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
        }
        
        d2SubCell.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(d1SubCell.snp.bottom)
            maker.bottom.equalToSuperview().offset(VerticalPixel(-10))
        }
    }
    
    
    
    private(set) lazy var vaccinatedLabel: HSLabel = {
        return createLabel(fontSize: 16, textColor: .black, numberOfLines: 0)
    }()
    
    private(set) lazy var vaccinatedCheckBox: HSCheckBox = {
        return createCheckBox()
    }()
    
    
    private(set) lazy var d1SubCell: RecordsSubCell = {
        let cell = RecordsSubCell(dataSource: self)
        cell.line.isHidden = false
        return cell
    }()
    
    private(set) lazy var d2SubCell: RecordsSubCell = {
        let cell = RecordsSubCell(dataSource: self)
        cell.line.isHidden = true
        return cell
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
