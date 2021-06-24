//
//  ViewController.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/3/31.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit


class ScanDetailViewController: UIViewController {
    private var root: DataFieldModel?
    private var qrJson:QRJson?
    
    private var isShareState: Bool = false
    
    let defaults = UserDefaults.standard
    
    var detailIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupNavigation()
        
        setupUI()
        
        setupEvents()
        
        reloadData()
        
    }
    
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: 0x256ba9)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.hs_systemFont(size: 22, isBold: true)]
        self.navigationItem.title = "Detail"
//        self.title = "iVaxCert"
        
        let leftItem = UIBarButtonItem(customView: self.cancelButton)
        self.navigationItem.leftBarButtonItem = leftItem
        cancelButton.isHidden = false
//        let rightItem = UIBarButtonItem(customView: self.customButton)
//        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func cancelButtonTouchUp() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
//            maker.height.equalToSuperview().multipliedBy(1.5)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
            
        }
        
        contentView.addSubview(imageViewVerified)
        imageViewVerified.snp.makeConstraints{ (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(27))
            maker.right.equalToSuperview().offset(HorizontalPixel(-27))
            maker.top.equalToSuperview().offset(VerticalPixel(-10))
        }
        
        
        contentView.addSubview(personalCell)
        personalCell.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(27))
            maker.right.equalToSuperview().offset(HorizontalPixel(-27))
            maker.top.equalToSuperview().offset(VerticalPixel(150))
        }
        
        
        
        
        contentView.addSubview(recordsCell)
        recordsCell.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(personalCell)
            maker.top.equalTo(personalCell.snp.bottom).offset(VerticalPixel(15))
        }
//        jsonTextView.isHidden = false
//        contentView.addSubview(jsonTextView)
//        jsonTextView.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(recordsCell)
//            maker.top.equalTo(recordsCell.snp.bottom).offset(VerticalPixel(15))
//        }
        
        jsonLabel.isHidden = false
        contentView.addSubview(jsonLabel)
        jsonLabel.snp.makeConstraints{ (maker) in
            maker.left.right.equalTo(recordsCell)
            maker.top.equalTo(recordsCell.snp.bottom).offset(VerticalPixel(15))
            maker.bottom.equalToSuperview().offset(VerticalPixel(15))
//            maker.height.equalTo(VerticalPixel(600))
        }
        
        testResultsCell.isHidden = true
        contentView.addSubview(testResultsCell)
        testResultsCell.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(personalCell)
            maker.top.equalTo(jsonLabel.snp.bottom).offset(VerticalPixel(15))
        }
        
        shareButton.isHidden = true
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(testResultsCell.snp.bottom).offset(VerticalPixel(70))
            maker.bottom.equalToSuperview().offset(VerticalPixel(-70))
            maker.height.equalTo(VerticalPixel(60))
        }
        
        qrCodeButton.isHidden = true
        self.view.addSubview(qrCodeButton)
        qrCodeButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(VerticalPixel(-100 - SafeAreaInsets.bottom))
            maker.width.height.equalTo(qrCodeButton.width)
        }
        
    }
    
    private func reloadData() {
//        root = DataFieldModel.createTestRoot()
        if ( self.defaults.object(forKey: "qr_record") == nil) {
//            back to last page
        } else {
            let arr = self.defaults.object(forKey: "qr_record")as? [String] ?? [String]()
//            var index = ((indexPath.row - arr.count)>0)?(indexPath.row - arr.count):((indexPath.row - arr.count)*-1)
            let jsonData = arr[detailIndex].data(using: .utf8)!
            
            print(arr[detailIndex])
            jsonLabel.text = "Scan Result:\n" + arr[detailIndex].replacingOccurrences(of: "\",\"", with: "\",\n\"").replacingOccurrences(of: "{", with: "{\n").replacingOccurrences(of: "}", with: "\n}")
            
            var qrJson: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
            self.qrJson = qrJson
            qrJson.validFlag = SearchViewController().verifyData(qrData: qrJson)
            if qrJson.validFlag! == false {

                imageViewVerified.image = UIImage(named: "failed.png")?.imageWithInsets(insetDimen: 10.0)
                   
            } else if  (qrJson.vaxDate_2 != nil && qrJson.vaxDate_2 != "" && SearchViewController().ifTwoWeek(dateStr: qrJson.vaxDate_2!)){
                imageViewVerified.image = UIImage(named: "verified_green.png")?.imageWithInsets(insetDimen: 10.0)
            }
            root = DataFieldModel.createQR(qr: qrJson)
            
            guard let `root` = root else { return }
            
            if let efn = root.child(withType: .EFN) {
                personalCell.familyNameLabel.text = efn.value
                setTag(withLabel: personalCell.familyNameLabel, checkBox: personalCell.familyNameCheckBox, field: efn)
                
            }
            if let egn = root.child(withType: .EGN) {
                personalCell.givenNameLabel.text = ((egn.value.count==1) ? egn.value+"****" : egn.value)
                setTag(withLabel: personalCell.givenNameLabel, checkBox: personalCell.givenNameCheckBox, field: egn)
                
            }
            if let dt = root.child(withType: .DT) {
                personalCell.documentTypeLabel.text = dt.value
                
                setTag(withLabel: personalCell.documentTypeLabel, checkBox: personalCell.documentTypeCheckBox, field: dt)
            }
            if let dn = root.child(withType: .DN) {
                personalCell.documentNoLabel.text = dn.value
                
                setTag(withLabel: personalCell.documentNoLabel, checkBox: personalCell.documentNoCheckBox, field: dn)
            }
            
            if let fvn = root.child(withType: .FVN) {
                recordsCell.vaccinatedLabel.text = ((fvn.value.count == 64) ? "*****":fvn.value)
                
                setTag(withLabel: recordsCell.vaccinatedLabel, checkBox: recordsCell.vaccinatedCheckBox, field: fvn)
            }
            if let fvln = root.child(withType: .FVLN) {
                recordsCell.d1SubCell.lnLabel.text = ((fvln.value.count == 64) ? "*****":fvln.value)
                
                setTag(withLabel: recordsCell.d1SubCell.lnLabel, checkBox: recordsCell.d1SubCell.lnCheckBox, field: fvln)
            }
            if let fvd = root.child(withType: .FVD) {
                recordsCell.d1SubCell.dateLabel.text =  ((fvd.value.count == 64) ? "*****":fvd.value)
                
                setTag(withLabel: recordsCell.d1SubCell.dateLabel, dsView: recordsCell.d1SubCell.dateSettingsView, field: fvd)
            }
            if let fvp = root.child(withType: .FVP) {
                recordsCell.d1SubCell.vpLabel.text = ((fvp.value.count == 64) ? "*****":fvp.value)
                
                setTag(withLabel: recordsCell.d1SubCell.vpLabel, checkBox: recordsCell.d1SubCell.vpCheckBox, field: fvp)
            }
            
            if let svln = root.child(withType: .SVLN) {
                recordsCell.d2SubCell.lnLabel.text = ((svln.value.count == 64) ? "*****":svln.value)
                
                setTag(withLabel: recordsCell.d2SubCell.lnLabel, checkBox: recordsCell.d2SubCell.lnCheckBox, field: svln)
            }
            if let svd = root.child(withType: .SVD) {
                recordsCell.d2SubCell.dateLabel.text = ((svd.value.count == 64) ? "*****":svd.value)
                
                setTag(withLabel: recordsCell.d2SubCell.dateLabel, dsView: recordsCell.d2SubCell.dateSettingsView, field: svd)
            }
            if let svp = root.child(withType: .SVP) {
                recordsCell.d2SubCell.vpLabel.text = ((svp.value.count == 64) ? "*****":svp.value)
                
                setTag(withLabel: recordsCell.d2SubCell.vpLabel, checkBox: recordsCell.d2SubCell.vpCheckBox, field: svp)
            }
        
            reloadTestResults()
            
        }
    }
    private(set) lazy var imageViewVerified: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "verified_yellow.png")?.imageWithInsets(insetDimen: 10.0)
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
    @objc private func editFirstName(){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Update Family name", message: "Enter new family name", preferredStyle: .alert)
        let defaults = UserDefaults.standard
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text)")
            if (textField!.text != "") {
                self.personalCell.familyNameLabel.text = textField!.text
                defaults.set(textField!.text,forKey: "EFN")
            }
            
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func editLastName(){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Update Given Name", message: "Enter new given name", preferredStyle: .alert)
        let defaults = UserDefaults.standard
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            if (textField!.text != "") {
                self.personalCell.givenNameLabel.text = textField!.text
                defaults.set(textField!.text,forKey: "EGN")
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    private func reloadTestResults() {
        guard let `root` = root else { return }
        guard let subfield = root.parent(withSubType: .NSCD) else { return }
        guard let parent = root.parent(withField: subfield) else { return }
        
        var isBindingN = false
        var isBindingI = false
        for i in 0..<parent.children.count {
            if testResultsCell.subcells.count > i {
                let subcell = testResultsCell.subcells[i]
                let field = parent.children[i]
                
                var isN = false
                var isI = false
                for sf in field.children {
                    switch sf.fieldType {
                    case .NSCD, .ISCD:
                        subcell.dateLabel.text = sf.value
                        
                        setTag(withLabel: subcell.dateLabel, dsView: subcell.dateSettingsView, field: sf)
                        
                        if (sf.fieldType == .NSCD && isBindingN) || (sf.fieldType == .ISCD && isBindingI) {
                            sf.needsHashFlags = true
                        }
                        
                        if sf.fieldType == .NSCD {
                            isN = true
                        } else {
                            isI = true
                        }
                    case .NTR, .ITR:
                        if let ret = TestResult(rawValue: sf.value) {
                            subcell.testResult = ret
                        }
                        
                        setTag(withLabel: subcell.testResultLabel, checkBox: subcell.trCheckBox, field: sf)
                        
                        if (sf.fieldType == .NTR && isBindingN) || (sf.fieldType == .ITR && isBindingI) {
                            sf.needsHashFlags = true
                        }
                        
                        if sf.fieldType == .NTR {
                            subcell.testNameLabel.text = "Nucleic Acid Test"
                            isN = true
                        } else {
                            subcell.testNameLabel.text = "Serum IgG Antibody Test"
                            isI = true
                        }
                    default:
                        break
                    }
                }
                
                if isN {
                    isBindingN = true
                }
                if isI {
                    isBindingI = true
                }
            }
        }
    }
    private func setTag(withLabel label: HSLabel? = nil, checkBox: HSCheckBox? = nil, dsView: HSTriangleView? = nil, field: DataFieldModel) {
        if label != nil {
            label!.tag = field.fieldType.rawValue
            label!.specialTag = field.uuid
        }
        
        if checkBox != nil {
            checkBox!.tag = field.fieldType.rawValue
            checkBox!.specialTag = field.uuid
        }
        
        if dsView != nil {
            dsView!.tag = field.fieldType.rawValue
            dsView!.specialTag = field.uuid
        }
    }
    
    private func setupEvents() {
        let checkBoxBlock = { [weak self] (sender: HSCheckBox) in
            guard let `self` = self else { return }
            guard let `root` = self.root else { return }
            guard let field = root.findFieldWithUUID(sender.specialTag) else { return }
            field.needsHashFlags = !sender.isChecked
            
            if field.fieldType == .FVN {
                if let svn = root.child(withType: .SVN) {
                    svn.needsHashFlags = field.needsHashFlags
                }
            }
        }
        
        let dateSettingsBlock = { [weak self] (sender: HSTriangleView, cell: BaseContentCell) in
            guard let `self` = self else { return }
            self.setDateStyle(sender, cell: cell)
        }
        
        personalCell.checkBoxDidClickBlock = checkBoxBlock
        
        recordsCell.checkBoxDidClickBlock = checkBoxBlock
        recordsCell.dateSettingsDidClickBlock = dateSettingsBlock
        
        testResultsCell.checkBoxDidClickBlock = checkBoxBlock
        testResultsCell.dateSettingsDidClickBlock = dateSettingsBlock
        
        shareButton.didClickBlock = { [weak self] in
            print("share btn click 282")
            guard let `self` = self else { return }
            self.changeShareState()
            
            self.templateOptView.show(on: self.view)
            
        }
        
        qrCodeView.didSaveBlock = { [weak self] in
            guard let `self` = self else { return }
            self.qrCodeButton.isHidden = false
            self.customButton.isHidden = false
        }
        qrCodeView.cancelBlock = { [weak self] in
            guard let `self` = self else { return }
            self.qrCodeButton.isHidden = false
            self.customButton.isHidden = false
        }
    }
    private func changeShareState() {
        self.isShareState = !self.isShareState
        
        if self.isShareState {
            self.shareButton.isHidden = true
            self.qrCodeButton.isHidden = false
            self.cancelButton.isHidden = false
            self.customButton.isHidden = false

            self.testResultsCell.isHideShowAllView = true
        } else {
            self.qrCodeButton.isHidden = true
            self.customButton.isHidden = true
            self.cancelButton.isHidden = true
            self.shareButton.isHidden = false

            self.testResultsCell.isHideShowAllView = false
        }

        self.refreshControls()
    }
    private func refreshControls(andSetValue value: Bool? = nil) {
        let state = isShareState
        self.personalCell.checkBoxArray.forEach { cb in
            self.selectAllCheckBox(cb, value: value, onCell: self.personalCell)
        }
        self.recordsCell.checkBoxArray.forEach { (cb) in
            self.selectAllCheckBox(cb, value: value, onCell: self.recordsCell)
        }
        self.recordsCell.dateSettingsArray.forEach { (ds) in
            ds.isHidden = !state
        }
        self.testResultsCell.checkBoxArray.forEach { (cb) in
            self.selectAllCheckBox(cb, value: value, onCell: self.testResultsCell)
        }
        self.testResultsCell.dateSettingsArray.forEach { (ds) in
            ds.isHidden = !state
        }
    }
    private func selectAllCheckBox(_ checkBox: HSCheckBox, value: Bool? = nil, onCell cell: BaseContentCell) {
        // Hide checkbox when try to share
        
        checkBox.isHidden = !isShareState
        
        if value != nil {
            checkBox.isChecked = value!
            
            if let field = root?.findFieldWithUUID(checkBox.specialTag) {
                field.needsHashFlags = !checkBox.isChecked
            }
        }
        
        var secure = false
        if isShareState {
            secure = !checkBox.isChecked
        }
        cell.setLabelSecureText(value: secure, tag: checkBox.specialTag)
    }
    
    @objc private func qrCodeTapHandler() {
        guard let `root` = root else { return }
        
        if qrCodeView.superview == nil {
            root.calcHashValue()
            
            qrCodeButton.isHidden = true
            
            customButton.isHidden = true
            
            qrCodeView.show(on: self.view)
            // pass different json string to the view
            //
            qrCodeView.generateQRCode(value: root.jsonString())
        }
    }
    
    @objc private func customButtonTouchUp() {
//        showCustomMessageDialog()
        self.templateOptView.show(on: self.view)
    }
    
    private func showCustomMessageDialog() {
        let dialog = HSDialog(message: "Sharing with")
        
        let action0 = HSDialogAction(title: "Select All") {
            self.refreshControls(andSetValue: true)
        }
        dialog.addAction(action0)
        
        let action1 = HSDialogAction(title: "Template - Airline") {
            self.customMessageTemplate()
        }
        dialog.addAction(action1)
        
        let action2 = HSDialogAction(title: "Clear All") {
            self.refreshControls(andSetValue: false)
        }
        dialog.addAction(action2)
        
        let action3 = HSDialogAction(title: "Cancel")
        dialog.addAction(action3)
        
        dialog.show()
    }
    private func customMessageTemplate() {
        self.personalCell.checkBoxArray.forEach { (cb) in
            self.selectAllCheckBox(cb, value: false, onCell: self.personalCell)
        }
        self.testResultsCell.checkBoxArray.forEach { (cb) in
            self.selectAllCheckBox(cb, value: false, onCell: self.testResultsCell)
        }
        
        self.recordsCell.checkBoxArray.forEach { (cb) in
            self.selectAllCheckBox(cb, value: true, onCell: self.recordsCell)
        }
    }
    
    
    private func setDateStyle(_ sender: HSTriangleView, cell: BaseContentCell) {
        guard let `root` = self.root else { return }
        guard let field = root.findFieldWithUUID(sender.specialTag) else { return }
        
        showDateSettingsDialog { [weak field] (style) in
            guard let `field` = field else { return }
            
            sender.value = style.rawValue
            field.dateStyle = style
            
            cell.setLabelDateText(field.value, tag: sender.specialTag)
        }
    }
    private func showDateSettingsDialog(completed: @escaping (_ style: DateStyle) -> Void) {
        let dialog = HSDialog(message: "Show the record in")
        
        let action0 = HSDialogAction(title: "Exact Date") {
            completed(.exact)
        }
        dialog.addAction(action0)
        
        let action1 = HSDialogAction(title: "One Week") {
            completed(.week)
        }
        dialog.addAction(action1)
        
        let action2 = HSDialogAction(title: "One Month") {
            completed(.month)
        }
        dialog.addAction(action2)
        
        let action3 = HSDialogAction(title: "Cancel")
        dialog.addAction(action3)
        
        dialog.show()
    }
    
    
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        
        return sv
    }()
    
    private lazy var scrollViewJson: UIScrollView = {
        let sv = UIScrollView()
        
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var personalCell: PersonalCell = {
        let cell = PersonalCell()
        return cell
    }()
    
    private lazy var recordsCell: RecordsCell = {
        let cell = RecordsCell()
        return cell
    }()
    
    private lazy var testResultsCell: TestResultsCell = {
        let cell = TestResultsCell()
        return cell
    }()
    
    private lazy var jsonLabel: PaddingLabel = {
        let l = PaddingLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        l.numberOfLines = 0
        l.backgroundColor = UIColor.white
//        l.shadowColor = UIColor.lightGray
        l.layer.cornerRadius = 20
        l.layer.borderWidth = 1
        l.layer.borderColor = UIColor.lightGray.cgColor
        return l
    }()
    private lazy var shareButton: HSShareButton = {
        return HSShareButton()
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
        btn.setImage(UIImage(named: "icon_back"), for: .normal)
        btn.addTarget(self, action: #selector(cancelButtonTouchUp), for: .touchUpInside)
        return btn
    }()
    
    private lazy var customButton: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        btn.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 15, bottom: 7.5, right: 0)
        btn.setImage(UIImage(named: "icon_tick"), for: .normal)
        btn.addTarget(self, action: #selector(customButtonTouchUp), for: .touchUpInside)
        return btn
    }()
    
    private lazy var qrCodeButton: UIView = {
        let size = HorizontalPixel(100)
        let v = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        var shadow = HSShadow()
        shadow.color = UIColor.init(white: 0, alpha: 0.2)
        shadow.opacity = 1
        shadow.offset = CGSize(width: 0, height: 7)
        shadow.radius = 7
        shadow.cornerRadius = size / 2
        v.hs_setupShadow(shadow)
        
        let cv = UIView()
        cv.layer.cornerRadius = size / 2
        cv.backgroundColor = UIColor(hex: 0xfca427)
        v.addSubview(cv)
        cv.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        let iv = UIImageView()
        iv.image = UIImage(named: "QRcode")
        cv.addSubview(iv)
        iv.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(HorizontalPixel(70))
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(qrCodeTapHandler))
        cv.addGestureRecognizer(tap)
        
        return v
    }()
    
    private lazy var qrCodeView: QRCodeView = {
        let v = QRCodeView()
        return v
    }()
    private lazy var templateOptView: TemplateOptView = {
        let v = TemplateOptView()
        v.tag = 100
        return v
    }()
    
    func staticQR(json:String){
        print("call")
            

        
        qrCodeView.show()
        
        qrCodeView.generateQRCode(value: json)
        
    }
//    private func customMessageTemplate() {
//        self.personalCell.checkBoxArray.forEach { (cb) in
//            self.selectAllCheckBox(cb, value: false, onCell: self.personalCell)
//        }
//        self.testResultsCell.checkBoxArray.forEach { (cb) in
//            self.selectAllCheckBox(cb, value: false, onCell: self.testResultsCell)
//        }
//
//        self.recordsCell.checkBoxArray.forEach { (cb) in
//            self.selectAllCheckBox(cb, value: true, onCell: self.recordsCell)
//        }
//    }
    func templateQR(type:String){
        
//        customMessageTemplate()
        switch type {
        case "restaurant":
            reloadDataTemplateRes()
        case "airplane":
            reloadDataTemplateAir()
        case "custom":
            reloadDataTemplateCustom()
        default:
            self.changeShareState()
        }
        
        print(root?.jsonString())
        guard let `root` = root else { return }
        
//        if qrCodeView.superview == nil {
            root.calcHashValue()
            
//            qrCodeButton.isHidden = true
//
//            customButton.isHidden = true
            
            qrCodeView.show()
            // pass different json string to the view
            //
            print(root.jsonString())
            qrCodeView.generateQRCode(value: root.jsonString())
//        }
    }
    
    @objc func templateTappedRes(gesture: UIGestureRecognizer) {
        print("Restaurant click")

        templateQR(type: "restaurant")
        
    }
    @objc func templateTappedAir(gesture: UIGestureRecognizer) {
        print("Airline click")
        templateQR(type: "airplane")
        
    }
    @objc func templateTappedCustom(gesture: UIGestureRecognizer) {
        print("Custom click")
        templateQR(type: "custom")
    }
    @objc func templateTappedCustomize(gesture: UIGestureRecognizer) {
        print("Customize click")
        templateQR(type: "customize")
    }
    private func reloadDataTemplateRes() {
        root = DataFieldModel.createTestRoot()
        guard let `root` = root else { return }
        
        if let efn = root.child(withType: .EFN) {
            efn.needsHashFlags = false
        }
        if let egn = root.child(withType: .EGN) {
            egn.value = String(egn.value.prefix(1))
            egn.needsHashFlags = false
        }
        if let dt = root.child(withType: .DT) {
            dt.needsHashFlags = true
        }
        if let dn = root.child(withType: .DN) {
            dn.needsHashFlags = true
        }
        
        if let fvn = root.child(withType: .FVN) {
            fvn.needsHashFlags = true
        }
        if let fvln = root.child(withType: .FVLN) {
            fvln.needsHashFlags = true
        }
        if let fvd = root.child(withType: .FVD) {
            fvd.needsHashFlags = false
        }
        if let fvp = root.child(withType: .FVP) {
            fvp.needsHashFlags = true
        }
        
        if let svln = root.child(withType: .SVLN) {
            svln.needsHashFlags = true
        }
        if let svd = root.child(withType: .SVD) {
            svd.needsHashFlags = false
        }
        if let svp = root.child(withType: .SVP) {
            svp.needsHashFlags = true
        }
    }
    private func reloadDataTemplateAir() {
        root = DataFieldModel.createTestRoot()
        guard let `root` = root else { return }
        
        if let efn = root.child(withType: .EFN) {
            efn.needsHashFlags = false
        }
        if let egn = root.child(withType: .EGN) {
//            egn.value = String(egn.value.prefix(1))
            egn.needsHashFlags = false
        }
        if let dt = root.child(withType: .DT) {
            
            dt.needsHashFlags = false
        }
        if let dn = root.child(withType: .DN) {
            dn.value = String(dn.value.prefix(4))
            dn.needsHashFlags = false
        }
        
        if let fvn = root.child(withType: .FVN) {
            fvn.needsHashFlags = true
        }
        if let fvln = root.child(withType: .FVLN) {
            fvln.needsHashFlags = true
        }
        if let fvd = root.child(withType: .FVD) {
            fvd.needsHashFlags = false
        }
        if let fvp = root.child(withType: .FVP) {
            fvp.needsHashFlags = true
        }
        
        if let svln = root.child(withType: .SVLN) {
            svln.needsHashFlags = true
        }
        if let svd = root.child(withType: .SVD) {
            svd.needsHashFlags = false
        }
        if let svp = root.child(withType: .SVP) {
            svp.needsHashFlags = true
        }
    }
    private func reloadDataTemplateCustom() {
        root = DataFieldModel.createTestRoot()
        guard let `root` = root else { return }
        
        if let efn = root.child(withType: .EFN) {
            efn.needsHashFlags = false
        }
        if let egn = root.child(withType: .EGN) {
//            egn.value = String(egn.value.prefix(1))
            egn.needsHashFlags = false
        }
        if let dt = root.child(withType: .DT) {
            
            dt.needsHashFlags = false
        }
        if let dn = root.child(withType: .DN) {
//            dn.value = String(dn.value.prefix(4))
            dn.needsHashFlags = false
        }
        
        if let fvn = root.child(withType: .FVN) {
            fvn.needsHashFlags = false
        }
        if let fvln = root.child(withType: .FVLN) {
            fvln.needsHashFlags = false
        }
        if let fvd = root.child(withType: .FVD) {
            fvd.needsHashFlags = false
        }
        if let fvp = root.child(withType: .FVP) {
            fvp.needsHashFlags = false
        }
        
        if let svln = root.child(withType: .SVLN) {
            svln.needsHashFlags = false
        }
        if let svd = root.child(withType: .SVD) {
            svd.needsHashFlags = false
        }
        if let svp = root.child(withType: .SVP) {
            svp.needsHashFlags = false
        }
    }
}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 7.0
    @IBInspectable var bottomInset: CGFloat = 7.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}