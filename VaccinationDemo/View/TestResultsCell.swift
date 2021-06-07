//
//  TestResultsCell.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/4.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit

protocol TestResultsSubCellDataSource: NSObjectProtocol {
    func createLabel(fontSize: CGFloat, textColor: UIColor, isBold: Bool, numberOfLines: Int) -> HSLabel
    
    func createCheckBox(isChecked: Bool, isHidden: Bool) -> HSCheckBox
    
    func createTriangleView(color: UIColor, insets: UIEdgeInsets, isHidden: Bool) -> HSTriangleView
}

class TestResultsSubCell: UIView {
    weak var dataSource: TestResultsSubCellDataSource?
    
    init(frame: CGRect = CGRect.zero, dataSource: TestResultsSubCellDataSource) {
        super.init(frame: frame)
        
        self.dataSource = dataSource
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(dateLabel)
        addSubview(dateSettingsView)
        addSubview(testNameLabel)
        addSubview(testResultBG)
        addSubview(trCheckBox)
        addSubview(line)
        
        testResultBG.addSubview(testResultLabel)
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(25))
            maker.top.equalToSuperview().offset(VerticalPixel(20))
        }
        
        dateSettingsView.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel.snp.right).offset(HorizontalPixel(3))
            maker.centerY.equalTo(dateLabel)
            maker.width.height.equalTo(30)
        }
        
        testNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel)
            maker.right.equalToSuperview().offset(HorizontalPixel(-25))
            maker.top.equalTo(dateLabel.snp.bottom).offset(VerticalPixel(15))
        }
        
        testResultBG.layer.cornerRadius = VerticalPixel(15)
        testResultBG.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel)
            maker.top.equalTo(testNameLabel.snp.bottom).offset(VerticalPixel(15))
            maker.height.equalTo(VerticalPixel(30))
        }
        
        testResultLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(HorizontalPixel(20))
            maker.right.equalToSuperview().offset(HorizontalPixel(-20))
        }
        
        trCheckBox.snp.makeConstraints { (maker) in
            maker.left.equalTo(testResultBG.snp.right).offset(HorizontalPixel(10))
            maker.centerY.equalTo(testResultBG)
            maker.width.height.equalTo(30)
        }
        
        line.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(23))
            maker.right.equalToSuperview().offset(HorizontalPixel(-23))
            maker.top.equalTo(testResultBG.snp.bottom).offset(VerticalPixel(15))
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1)
        }
    }
    
    
    
    var testResult: TestResult = .Negative {
        didSet {
            testResultLabel.text = testResult.name()
            
            switch testResult {
            case .Negative:
                testResultLabel.textColor = UIColor(hex: 0x2ab421)
                testResultBG.backgroundColor = UIColor(red: 231, green: 246, blue: 226)
            case .Positive:
                testResultLabel.textColor = UIColor(hex: 0xb42121)
                testResultBG.backgroundColor = UIColor(red: 245, green: 225, blue: 225)
            }
        }
    }
    
    private(set) lazy var dateLabel: HSLabel = {
        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: UIColor(hex: 0xfca427), isBold: false, numberOfLines: 1) else {
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
    
    private(set) lazy var testNameLabel: HSLabel = {
        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: .black, isBold: false, numberOfLines: 0) else {
            return HSLabel()
        }
        return lbl
    }()
    
    private(set) lazy var testResultBG: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 231, green: 246, blue: 226)
        return v
    }()
    
    private(set) lazy var testResultLabel: HSLabel = {
        guard let lbl = dataSource?.createLabel(fontSize: 16, textColor: .black, isBold: false, numberOfLines: 1) else {
            return HSLabel()
        }
        lbl.textColor = UIColor(hex: 0x2ab421)
        return lbl
    }()
    
    private(set) lazy var trCheckBox: HSCheckBox = {
        guard let cb = dataSource?.createCheckBox(isChecked: false, isHidden: true) else {
            return HSCheckBox()
        }
        return cb
    }()
    
    private(set) lazy var line: UIView = {
        let l = UIView()
        l.backgroundColor = UIColor(hex: 0xe5e5e5)
        return l
    }()
}



class TestResultsCell: BaseContentCell, TestResultsSubCellDataSource {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleView.titleLabel.text = "Test Results"
        self.titleView.iconView.image = UIImage(named: "testIcon")
        self.titleView.iconView.snp.updateConstraints { (maker) in
            maker.width.height.equalTo(VerticalPixel(40))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupCenterView() {
        self.centerView.addSubview(trCell0)
//        self.centerView.addSubview(trCell1)
        
        trCell0.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalToSuperview()
        }
//
//        trCell1.snp.makeConstraints { (maker) in
//            maker.left.right.bottom.equalToSuperview()
//            maker.top.equalTo(trCell0.snp.bottom)
//        }
    }
    
    override func setupBottomView() {
//        self.bottomView.addSubview(trCell0)
//        trCell0.snp.makeConstraints { (maker) in
//            maker.left.top.right.equalToSuperview()
//        }
        self.bottomView.addSubview(trCell1)
        trCell1.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
//            maker.top.equalTo(trCell0.snp.bottom)
        }
        self.bottomView.addSubview(trCell2)
        trCell2.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(trCell1.snp.bottom)
        }
    }
    
    
    
    private(set) lazy var subcells: [TestResultsSubCell] = {
        return [trCell0, trCell1, trCell2]
    }()
    private(set) lazy var trCell0: TestResultsSubCell = {
        let cell = TestResultsSubCell(dataSource: self)
        cell.line.isHidden = false
        return cell
    }()
    
    private(set) lazy var trCell1: TestResultsSubCell = {
        let cell = TestResultsSubCell(dataSource: self)
        cell.line.isHidden = true
        return cell
    }()
    
    private(set) lazy var trCell2: TestResultsSubCell = {
        let cell = TestResultsSubCell(dataSource: self)
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
