//
//  ViewController.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/3/31.
//  Copyright © 2021 guofeng. All rights reserved.
//

import UIKit
import Alamofire

enum VaccPage {
    case index
    case edit
    case qrCode
}

class MainViewController: UIViewController {
    private var root: DataFieldModel?
    
    private var isShareState: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("abcd".sha256)
        setupNavigation()
        
        setupUI()
        
        setupEvents()
        
        reloadData()
        
    }
    
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: 0x256ba9)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.hs_systemFont(size: 22, isBold: true)]
        self.navigationItem.title = "Health Wallet"
//        self.title = "iVaxCert"
        
        let leftItem = UIBarButtonItem(customView: self.cancelButton)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(customView: self.customButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func cancelButtonTouchUp() {
        if qrCodeView.superview == nil {
            self.changeShareState()
        } else {
            qrCodeView.dismiss()
            
            qrCodeButton.isHidden = false
            
            customButton.isHidden = false
            
            templateOptView.dismiss()
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
        }
        
        contentView.addSubview(personalCell)
        personalCell.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(HorizontalPixel(27))
            maker.right.equalToSuperview().offset(HorizontalPixel(-27))
            maker.top.equalToSuperview().offset(VerticalPixel(15))
        }
        
        contentView.addSubview(recordsCell)
        recordsCell.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(personalCell)
            maker.top.equalTo(personalCell.snp.bottom).offset(VerticalPixel(15))
        }
        
//        contentView.addSubview(testResultsCell)
//        testResultsCell.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(personalCell)
//            maker.top.equalTo(recordsCell.snp.bottom).offset(VerticalPixel(15))
//        }
        
        shareButton.isHidden = false
        contentView.addSubview(shareButton)
        shareButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(recordsCell.snp.bottom).offset(VerticalPixel(50))
            maker.bottom.equalToSuperview().offset(VerticalPixel(-50))
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
        root = DataFieldModel.createTestRoot()
        guard let `root` = root else { return }
        
        if let efn = root.child(withType: .EFN) {
            personalCell.familyNameLabel.text = efn.value
            
            setTag(withLabel: personalCell.familyNameLabel, checkBox: personalCell.familyNameCheckBox, field: efn)
            personalCell.familyNameLabel.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(editFirstName))
            personalCell.familyNameLabel.addGestureRecognizer(tap)
        }
        if let egn = root.child(withType: .EGN) {
            personalCell.givenNameLabel.text = egn.value
            personalCell.givenNameLabel.isUserInteractionEnabled = true
            setTag(withLabel: personalCell.givenNameLabel, checkBox: personalCell.givenNameCheckBox, field: egn)
            let tap = UITapGestureRecognizer(target: self, action: #selector(editLastName))
            personalCell.givenNameLabel.addGestureRecognizer(tap)
        }
        if let dt = root.child(withType: .DT) {
            personalCell.documentTypeLabel.text = dt.value
            
            setTag(withLabel: personalCell.documentTypeLabel, checkBox: personalCell.documentTypeCheckBox, field: dt)
        }
        if let dn = root.child(withType: .DN) {
            personalCell.documentNoLabel.text = dn.value
            
            setTag(withLabel: personalCell.documentNoLabel, checkBox: personalCell.documentNoCheckBox, field: dn)
        }
        
        
        if let idphoto = root.child(withType: .PID) {
            print("Image url")
            print(idphoto.value)
            let url = URL(string: idphoto.value)

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                print(data)
                DispatchQueue.main.async {
//                    print("run")
                    let defaultData = UIImage(named: "user.png")?.pngData()
                    self.personalCell.docPhotoView.image = UIImage(data: ((data ?? defaultData)!))
                }
            }
        }
        
        if let pnf = root.child(withType: .PNF) {
            personalCell.passNoLabel.text = pnf.value
            
            setTag(withLabel: personalCell.passNoLabel, checkBox: personalCell.passNoCheckBox, field: pnf)
        }
        if let pnl = root.child(withType: .PNL) {
            personalCell.passNoLabel.text! += pnl.value
            
//            setTag(withLabel: personalCell.passNoLabel, checkBox: personalCell.passNoCheckBox, field: pnl)
        }
        if let  mtpnf = root.child(withType: .MTPNF) {
            personalCell.mpNoLabel.text = mtpnf.value
            
            setTag(withLabel: personalCell.mpNoLabel, checkBox: personalCell.mpNoCheckBox, field: mtpnf)
        }
        if let  mtpnl = root.child(withType: .MTPNL) {
            personalCell.mpNoLabel.text! += mtpnl.value
            
//            setTag(withLabel: personalCell.mpNoLabel, checkBox: personalCell.mpNoCheckBox, field: mtpnf)
        }
        
        
        if let fvn = root.child(withType: .FVN) {
            recordsCell.vaccinatedLabel.text = fvn.value
            
            setTag(withLabel: recordsCell.vaccinatedLabel, checkBox: recordsCell.vaccinatedCheckBox, field: fvn)
        }
        if let fvln = root.child(withType: .FVLN) {
            recordsCell.d1SubCell.lnLabel.text = fvln.value
            
            setTag(withLabel: recordsCell.d1SubCell.lnLabel, checkBox: recordsCell.d1SubCell.lnCheckBox, field: fvln)
        }
        if let fvd = root.child(withType: .FVD) {
            recordsCell.d1SubCell.dateLabel.text = fvd.value
            
            setTag(withLabel: recordsCell.d1SubCell.dateLabel, checkBox: recordsCell.d1SubCell.vaccinatedDateCheckBox, field: fvd)
//            setTag(withLabel: recordsCell.d1SubCell.dateLabel, dsView: recordsCell.d1SubCell.dateSettingsView, field: fvd)
        }
        if let fvp = root.child(withType: .FVP) {
            recordsCell.d1SubCell.vpLabel.text = fvp.value
            
            setTag(withLabel: recordsCell.d1SubCell.vpLabel, checkBox: recordsCell.d1SubCell.vpCheckBox, field: fvp)
        }
        
        if let svln = root.child(withType: .SVLN) {
            recordsCell.d2SubCell.lnLabel.text = svln.value
            
            setTag(withLabel: recordsCell.d2SubCell.lnLabel, checkBox: recordsCell.d2SubCell.lnCheckBox, field: svln)
        }
        if let svd = root.child(withType: .SVD) {
            recordsCell.d2SubCell.dateLabel.text = svd.value
            setTag(withLabel: recordsCell.d2SubCell.dateLabel, checkBox: recordsCell.d2SubCell.vaccinatedDateCheckBox, field: svd)
//            setTag(withLabel: recordsCell.d2SubCell.dateLabel, dsView: recordsCell.d2SubCell.dateSettingsView, field: svd)
        }
        if let svp = root.child(withType: .SVP) {
            recordsCell.d2SubCell.vpLabel.text = svp.value
            
            setTag(withLabel: recordsCell.d2SubCell.vpLabel, checkBox: recordsCell.d2SubCell.vpCheckBox, field: svp)
        }
//        print(calInitRoot(root: root))
        
//        reloadTestResults()
    }
    private func calInitRoot(root: DataFieldModel)-> String {
        if let efn = root.child(withType: .EFN) {
            efn.needsHashFlags = false
        }
        if let egn = root.child(withType: .EGN) {
//            egn.value = String(egn.value.prefix(1))
            egn.needsHashFlags = false
        }
        if let egnf = root.child(withType: .EGNF){
            egnf.needsHashFlags = false
        }
        if let dt = root.child(withType: .DT) {
            
            dt.needsHashFlags = false
        }
        if let dn = root.child(withType: .DN) {
//            dn.value = String(dn.value.prefix(4))
            dn.needsHashFlags = false
        }
        if let dnf = root.child(withType: .DNF) {
//            dn.value = String(dn.value.prefix(4))
            dnf.needsHashFlags = false
        }
        if let dnl = root.child(withType: .DNL) {
//            dn.value = String(dn.value.prefix(4))
            dnl.needsHashFlags = false
        }
        if let pid = root.child(withType: .PID){
            pid.needsHashFlags = false
        }
        
        if let photoHash = root.child(withType: .PID_hash){
            photoHash.needsHashFlags = false
        }
        if let mtpnl = root.child(withType: .MTPNL) {
            
            mtpnl.needsHashFlags = false
        }
        if let mtpnf = root.child(withType: .MTPNF) {
            
            mtpnf.needsHashFlags = false
        }
        if let pnol = root.child(withType: .PNL) {
            
            pnol.needsHashFlags = false
        }
        if let pnof = root.child(withType: .PNF) {
            
            pnof.needsHashFlags = false
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
        if let svn = root.child(withType: .SVN) {
            svn.needsHashFlags = false
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
        print("root")
        print(root.jsonString())
        return MainViewController().calRoot(qrDataStr: root.jsonString())
        
    }
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
                self.reloadData()
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
                self.reloadData()
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
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
            // download the data here and write the data to default
            let alert = UIAlertController(title: "Fetch new data", message: "Enter DocID", preferredStyle: .alert)
            let defaults = UserDefaults.standard
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.placeholder = "HKID"
            }
            alert.addTextField { (textFieldPass) in
                    textFieldPass.placeholder = "Password"
                    textFieldPass.isSecureTextEntry = true
            }

            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                let textFieldPass = alert?.textFields![1]
                
                print("Text field: \(textField!.text ?? "a")")
                
                let params = [
                    "key": textField!.text ?? "M123456",
                    "pass": textFieldPass!.text ?? "butrace2021"
                ]
                print(params)
                Alamofire.request("https://butrace.hkbu.edu.hk/eHealthWallet/get_json.php", method: .post, parameters: params).responseJSON { response in
                    debugPrint(response)
                    let jsonData = response.data!
                                        
                    do {
                        try JSONDecoder().decode(QRJson.self, from: jsonData)
                    } catch let error {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Invalid data. Please try again.", message: nil, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            alert.addAction(cancelAction)
                            self!.present(alert, animated: true, completion: nil)
                        }
                        return
                    }
                    var qrData: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
                    defaults.set(qrData.engFamilyName, forKey: "EFN")
                    defaults.set(qrData.engGivenName, forKey: "EGN")
                    defaults.set(qrData.engGivenNameFirstLetter, forKey: "engGivenNameFirstLetter")
                    defaults.set(qrData.docType, forKey: "docType")
                    defaults.set(qrData.docNumber, forKey: "docNumber")
                    defaults.set(qrData.docNumberFirstHalf, forKey: "docNumberFirstHalf")
                    defaults.set(qrData.docNumberSecondHalf, forKey: "docNumberSecondHalf")
                    defaults.set(qrData.idPhoto, forKey: "idPhoto")
                    defaults.set(qrData.idPhotoHash, forKey: "idPhotoHash")
                    defaults.set(qrData.passportNumberFirstHalf, forKey: "passportNumberFirstHalf")
                    defaults.set(qrData.passportNumberSecondHalf, forKey: "passportNumberSecondHalf")
                    defaults.set(qrData.mainlandTravelPermitNoFirstHalf, forKey: "mainlandTravelPermitNoFirstHalf")
                    defaults.set(qrData.mainlandTravelPermitNoSecondHalf, forKey: "mainlandTravelPermitNoSecondHalf")
                    defaults.set(qrData.vaxName_1, forKey: "vaxName_1")
                    defaults.set(qrData.lotNumber_1, forKey: "lotNumber_1")
                    defaults.set(qrData.vaxDate_1, forKey: "vaxDate_1")
                    defaults.set(qrData.vaxLocation_1, forKey: "vaxLocation_1")
                    defaults.set(qrData.vaxName_2, forKey: "vaxName_2")
                    defaults.set(qrData.lotNumber_2, forKey: "lotNumber_2")
                    defaults.set(qrData.vaxDate_2, forKey: "vaxDate_2")
                    defaults.set(qrData.vaxLocation_2, forKey: "vaxLocation_2")
                    defaults.set(qrData.roothash, forKey: "roothash")
//                    print(self!.calRoot(qrDataStr: String(decoding: jsonData, as: UTF8.self)))
//                    print(qrData.roothash!)
//                    let params = [
//                        "command": "create",
//                        "id": qrData.roothash!.sha256,
//                        "records": "{rootHash:"+qrData.roothash!+"}"
//                    ]
//
//                    Alamofire.request("http://47.107.127.74/netAPI.php", method: .post, parameters: params).responseJSON { response in
//                        debugPrint(response)
//                    }
                    // write the data to user defaults
                    self!.reloadData()
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Demo data is updated", message: nil, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        self!.present(alert, animated: true, completion: nil)
                    }
                    print(self!.calRoot(qrDataStr: String(decoding: jsonData, as: UTF8.self)))
                    print(qrData.roothash!)
                    let params = [
                        "command": "create",
                        "id": qrData.roothash!.sha256,
                        "records": "{rootHash:"+qrData.roothash!+"}"
                    ]

                    Alamofire.request("http://47.107.127.74/netAPI.php", method: .post, parameters: params).responseJSON { response in
                        debugPrint(response)
                    }
                }
                
            }))

            // 4. Present the alert.
            self!.present(alert, animated: true, completion: nil)
            

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
//        self.isShareState = state
        if self.isShareState {
            self.shareButton.isHidden = true
            
            self.qrCodeButton.isHidden = false
            
            self.cancelButton.isHidden = false
//            self.customButton.setImage(UIImage(named: "icon_tick"), for: UIControl.State())
//            self.customButton.isHidden = false

            self.testResultsCell.isHideShowAllView = true
        } else {
            self.qrCodeButton.isHidden = true
            
//            self.customButton.setImage(UIImage(named: "shareicon"), for: UIControl.State())
//            self.customButton.isHidden = false
            
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
//            //  v date always show start
//            if let fvd = root.child(withType: .FVD) {
//                fvd.needsHashFlags = false
//            }
//            if let svd = root.child(withType: .SVD) {
//                svd.needsHashFlags = false
//            }
            // end
            
            if let pnf = root.child(withType: .PNF) {
                if pnf.isNeedsHash == false {
                    let pnl = root.child(withType: .PNL)
                    pnl?.needsHashFlags = false
                } else {
                    let pnl = root.child(withType: .PNL)
                    pnl?.needsHashFlags = true
                }
            }
            if let mtpnf = root.child(withType: .MTPNF) {
                if mtpnf.isNeedsHash == false {
                    let mtpnl = root.child(withType: .MTPNL)
                    mtpnl?.needsHashFlags = false
                } else {
                    let mtpnl = root.child(withType: .MTPNL)
                    mtpnl?.needsHashFlags = true
                }
                
            }
            
            if let photoHash = root.child(withType: .PID_hash){
                photoHash.needsHashFlags = false
            }
            root.calcHashValue()
            
//            qrCodeButton.isHidden = true
//
//            customButton.isHidden = true
            
//            qrCodeView.show(on: self.view)
//            qrCodeView.show()
            // pass different json string to the view
            //
            
            print(root.jsonString())
            let jsonData = appendRoot(qrDataStr: root.jsonString()).data(using: .utf8)!
            var qrJson: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
            var output_str = appendRoot(qrDataStr: root.jsonString())
            if  (qrJson.VR_node != nil || qrJson.VR_node_2 != nil || qrJson.leaf_vaxDate_2 != nil) {
                ///  Call BulletProofs
                ///
                
                print(root.child(withType: .SVD)?.value)
//                var dateProofs = BulletProofs()
                let proofStr = BulletProofs.genDateProof(root.child(withType: .SVD)?.value)
                print(proofStr)
                output_str = output_str.replacingOccurrences(of: "}", with: String(", " + proofStr! + " }"))
                print(output_str)
                if (qrCodeView.generateQRCode(value: output_str)){
                    qrCodeView.show()
                } else {
                    let alert = UIAlertController(title: "QR Code Error", message: "The Selected data is too long for QR code Generation", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                            case .default:
                            print("default")
                            
                            case .cancel:
                            print("cancel")
                            
                            case .destructive:
                            print("destructive")
                            
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                   
                }
            } else {
                if (qrCodeView.generateQRCode(value: output_str)){
                    qrCodeView.show()
                } else {
                    let alert = UIAlertController(title: "QR Code Error", message: "The Selected data is too long for QR code Generation", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                            case .default:
                            print("default")
                            
                            case .cancel:
                            print("cancel")
                            
                            case .destructive:
                            print("destructive")
                            
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
//            print(SearchViewController().verifyData(qrData: qrJson))
//            qrCodeView.generateQRCode(value: output_str)
        }
    }
    
    @objc private func customButtonTouchUp() {
//        showCustomMessageDialog()
//        templateOptView.show(on: self.view)
        if !self.isShareState {
            self.changeShareState()
        }
        templateOptView.show()
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
//        btn.isHidden = true
        btn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        btn.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 15, bottom: 7.5, right: 0)
        btn.setImage(UIImage(named: "shareIcon"), for: .normal)
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
            

        
//        qrCodeView.show()
        
        if(qrCodeView.generateQRCode(value: json)){
            qrCodeView.show()
        } else {
            let alert = UIAlertController(title: "QR Code Error", message: "The Selected data is too long for QR code Generation", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
            self.changeShareState()
            self.changeShareState()
        }
        
        
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
        var static_json:String = ""
//        customMessageTemplate()
        switch type {
        case "restaurant":
            reloadDataTemplateRes()
            
        case "airplane":
            reloadDataTemplateAir()
            
        case "custom":
            reloadDataTemplateCustom()
        
        case "customcn":
            reloadDataTemplateCustomCn()
           
        default:
            self.changeShareState()
        }
        
//        print(root?.jsonString())
        guard let `root` = root else { return }
        
//        if qrCodeView.superview == nil {
            root.calcHashValue()
            
//            qrCodeButton.isHidden = true
//
//            customButton.isHidden = true
            
//            qrCodeView.show()
            // pass different json string to the view
            //
//            print(root.jsonString())
            let output_str = appendRoot(qrDataStr: root.jsonString())
            let jsonData = output_str.data(using: .utf8)!
            let qrJson: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
            print("OUT____________________")
//            print(SearchViewController().verifyData(qrData: qrJson))
            print(output_str)
//            qrCodeView.generateQRCode(value: output_str)
//        print(qrJson.VR_node)
        
        if (qrCodeView.generateQRCode(value: output_str)){
            qrCodeView.show()
        } else {
            let alert = UIAlertController(title: "QR Code Error", message: "The Selected data is too long for QR code Generation", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
            self.changeShareState()
            self.changeShareState()
        }
            
            
        
//            qrCodeView.generateQRCode(value: static_json)
//        }
    }
    
    @objc func templateTappedRes(gesture: UIGestureRecognizer) {
        print("Restaurant click")
        // change to static format
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
    @objc func templateTappedCustomCn(gesture: UIGestureRecognizer) {
        print("Custom click")
        templateQR(type: "customcn")
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
            egn.needsHashFlags = true
        }
        if let egnf = root.child(withType: .EGNF){
            egnf.needsHashFlags = false
        }
        if let dt = root.child(withType: .DT) {
            dt.needsHashFlags = true
        }
        if let dn = root.child(withType: .DN) {
            dn.needsHashFlags = true
        }
        
        if let idphoto = root.child(withType: .PID){
            idphoto.needsHashFlags = false
        }
        
        if let photoHash = root.child(withType: .PID_hash){
            photoHash.needsHashFlags = false
        }
        
        if let fvn = root.child(withType: .FVN) {
            fvn.needsHashFlags = true
        }
        if let fvln = root.child(withType: .FVLN) {
            fvln.needsHashFlags = true
        }
        if let fvd = root.child(withType: .FVD) {
            fvd.needsHashFlags = true
        }
        if let fvp = root.child(withType: .FVP) {
            fvp.needsHashFlags = true
        }
        if let svn = root.child(withType: .SVN) {
            svn.needsHashFlags = true
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
        if let egnf = root.child(withType: .EGNF){
            egnf.needsHashFlags = false
        }
        if let dt = root.child(withType: .DT) {
            
            dt.needsHashFlags = true
        }
        if let dn = root.child(withType: .DN) {
            
            dn.needsHashFlags = true
        }
        if let dnf = root.child(withType: .DNF) {
            
            dnf.needsHashFlags = true
        }
        if let dnl = root.child(withType: .DNL) {
            
            dnl.needsHashFlags = false
        }
        
        if let pnol = root.child(withType: .PNL) {
            
            pnol.needsHashFlags = false
        }
        if let mtpnl = root.child(withType: .MTPNL) {
            
            mtpnl.needsHashFlags = false
        }
        
        if let photoHash = root.child(withType: .PID_hash){
            photoHash.needsHashFlags = false
        }
        if let fvn = root.child(withType: .FVN) {
            fvn.needsHashFlags = true
        }
        if let fvln = root.child(withType: .FVLN) {
            fvln.needsHashFlags = true
        }
        if let fvd = root.child(withType: .FVD) {
            fvd.needsHashFlags = true
        }
        if let fvp = root.child(withType: .FVP) {
            fvp.needsHashFlags = true
        }
        if let svn = root.child(withType: .SVN) {
            svn.needsHashFlags = true
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
        if let egnf = root.child(withType: .EGNF){
            egnf.needsHashFlags = false
        }
        if let dt = root.child(withType: .DT) {
            
            dt.needsHashFlags = true
        }
        if let dn = root.child(withType: .DN) {
//            dn.value = String(dn.value.prefix(4))
            dn.needsHashFlags = true
        }
        if let pnol = root.child(withType: .PNL) {
            
            pnol.needsHashFlags = false
        }
        if let pnof = root.child(withType: .PNF) {
            
            pnof.needsHashFlags = false
        }
        if let photoHash = root.child(withType: .PID_hash){
            photoHash.needsHashFlags = false
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
        if let svn = root.child(withType: .SVN) {
            svn.needsHashFlags = false
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
    private func reloadDataTemplateCustomCn() {
        root = DataFieldModel.createTestRoot()
        guard let `root` = root else { return }
        
        if let efn = root.child(withType: .EFN) {
            efn.needsHashFlags = false
        }
        if let egn = root.child(withType: .EGN) {
//            egn.value = String(egn.value.prefix(1))
            egn.needsHashFlags = false
        }
        if let egnf = root.child(withType: .EGNF){
            egnf.needsHashFlags = false
        }
        if let dt = root.child(withType: .DT) {
            
            dt.needsHashFlags = true
        }
        if let dn = root.child(withType: .DN) {
//            dn.value = String(dn.value.prefix(4))
            dn.needsHashFlags = true
        }
        if let photoHash = root.child(withType: .PID_hash){
            photoHash.needsHashFlags = false
        }
        if let mtpnl = root.child(withType: .MTPNL) {
            
            mtpnl.needsHashFlags = false
        }
        if let mtpnf = root.child(withType: .MTPNF) {
            
            mtpnf.needsHashFlags = false
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
        if let svn = root.child(withType: .SVN) {
            svn.needsHashFlags = false
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
//    private func appendRoot(qrDataStr:String)->String{
//        print("_______________________")
//        print(qrDataStr)
//        let jsonData = qrDataStr.data(using: .utf8)!
//        var qrData: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
//        var qrhash = ""
//        var qrhashPI = ""
//        var qrhashVR = ""
//        if qrData.PI_node == nil || qrData.PI_node == "" {
//            if  qrData.PI_node_1 == nil || qrData.PI_node_1 == "" {
//                var pi_node_1 =  (((qrData.engFamilyName != nil) ? qrData.engFamilyName!.sha256 : qrData.leaf_engFamilyName) ?? "")
//                pi_node_1 += (((qrData.engGivenName != nil) ? qrData.engGivenName!.sha256 : qrData.leaf_engGivenName) ?? "")
//                pi_node_1 += (((qrData.engGivenNameFirstLetter != nil) ? qrData.engGivenNameFirstLetter!.sha256 : qrData.leaf_engGivenNameFirstLetter) ?? "")
//                pi_node_1 += (((qrData.idPhoto != nil) ? qrData.idPhoto!.sha256 : qrData.leaf_idPhoto) ?? "")
//                pi_node_1 += (((qrData.idPhotoHash != nil) ? qrData.idPhotoHash! : qrData.leaf_idPhotoHash) ?? "")
//                qrhashPI += pi_node_1.sha256
//            } else {
//                qrhashPI += qrData.PI_node_1!
//            }
//            print(qrhashPI)
//            if  qrData.PI_node_2 == nil || qrData.PI_node_2 == "" {
//                var pi_node_2 = (((qrData.docType != nil) ? qrData.docType!.sha256 : qrData.leaf_docType) ?? "")
//                pi_node_2 += (((qrData.docNumber != nil) ? qrData.docNumber!.sha256 : qrData.leaf_docNumber) ?? "")
//                pi_node_2 += (((qrData.docNumberFirstHalf != nil) ? qrData.docNumberFirstHalf!.sha256 : qrData.leaf_docNumberFirstHalf) ?? "")
//                pi_node_2 += (((qrData.docNumberSecondHalf != nil) ? qrData.docNumberSecondHalf!.sha256 : qrData.leaf_docNumberSecondHalf) ?? "")
//                pi_node_2 += (((qrData.passportNumberFirstHalf != nil) ? qrData.passportNumberFirstHalf!.sha256 : qrData.leaf_passportNumberFirstHalf) ?? "")
//                pi_node_2 += (((qrData.passportNumberSecondHalf != nil) ? qrData.passportNumberSecondHalf!.sha256 : qrData.leaf_passportNumberSecondHalf) ?? "")
//                pi_node_2 += (((qrData.mainlandTravelPermitNoFirstHalf != nil) ? qrData.mainlandTravelPermitNoFirstHalf!.sha256 : qrData.leaf_mainlandTravelPermitNoFirstHalf) ?? "")
//                pi_node_2 += (((qrData.mainlandTravelPermitNoSecondHalf != nil) ? qrData.mainlandTravelPermitNoSecondHalf!.sha256 : qrData.leaf_mainlandTravelPermitNoSecondHalf) ?? "")
//                qrhashPI += pi_node_2.sha256
//            } else {
//                qrhashPI += qrData.PI_node_2 ?? ""
//            }
//            qrhashPI = qrhashPI.sha256
//        } else {
//            qrhashPI = qrData.PI_node ?? ""
//        }
//
//        print(qrhashPI)
//        qrhash += qrhashPI
//        if qrData.VR_node == nil || qrData.VR_node == "" {
//            if  qrData.VR_node_1 == nil || qrData.VR_node_1 == "" {
//                var vr_node_1 = (((qrData.vaxName_1 != nil) ? qrData.vaxName_1!.sha256 : qrData.leaf_vaxName_1) ?? "")
//                vr_node_1 += (((qrData.lotNumber_1 != nil) ? qrData.lotNumber_1!.sha256 : qrData.leaf_lotNumber_1) ?? "")
//                vr_node_1 += (((qrData.vaxDate_1 != nil) ? qrData.vaxDate_1!.sha256 : qrData.leaf_vaxDate_1) ?? "")
//                vr_node_1 += (((qrData.vaxLocation_1 != nil) ? qrData.vaxLocation_1!.sha256 : qrData.leaf_vaxLocation_1) ?? "")
//                qrhashVR += vr_node_1.sha256
//            } else {
//                qrhashVR += qrData.VR_node_1 ?? ""
//            }
//            print(qrhashVR)
//            if  qrData.VR_node_2 == nil || qrData.VR_node_2 == "" {
//                var vr_node_2 = (((qrData.vaxName_2 != nil) ? qrData.vaxName_2!.sha256 : qrData.leaf_vaxName_2) ?? "")
//                vr_node_2 += (((qrData.lotNumber_2 != nil) ? qrData.lotNumber_2!.sha256 : qrData.leaf_lotNumber_2) ?? "")
//                vr_node_2 += (((qrData.vaxDate_2 != nil) ? qrData.vaxDate_2!.sha256 : qrData.leaf_vaxDate_2) ?? "")
//                vr_node_2 += (((qrData.vaxLocation_2 != nil) ? qrData.vaxLocation_2!.sha256 : qrData.leaf_vaxLocation_2) ?? "")
//                qrhashVR += vr_node_2.sha256
//            } else {
//                qrhashVR += qrData.VR_node_2 ?? ""
//            }
//            qrhashVR = qrhashVR.sha256
//        } else {
//            qrhashVR = qrData.VR_node ?? ""
//        }
//        qrhash += qrhashVR
//
//        return qrDataStr.replacingOccurrences(of: "}", with: String(", \"rootSignature\": \"" + qrhash.sha256 + "\" }"))
//
//    }
    private func appendRoot(qrDataStr:String)->String{
        print("_______________________")
        print(qrDataStr)
        var rootHash = ""
        let defaults = UserDefaults.standard
        if UserDefaults.standard.object(forKey: "rootHash") != nil {
            print(defaults.string(forKey: "rootHash"))
            rootHash = defaults.string(forKey: "rootHash")!
        }
        
//        return qrDataStr.replacingOccurrences(of: "}", with: String(", \"rootSignature\": \"" + rootHash + "\" }"))
        return qrDataStr
    }
    func calRoot(qrDataStr:String)->String{
        print("_______________________")
        print(qrDataStr)
        let jsonData = qrDataStr.data(using: .utf8)!
        var qrData: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
        var qrhash = ""
        var qrhashPI = ""
        var qrhashVR = ""
        if qrData.PI_node == nil || qrData.PI_node == "" {
            if  qrData.PI_node_1 == nil || qrData.PI_node_1 == "" {
                var pi_node_1 =  (((qrData.engFamilyName != nil) ? qrData.engFamilyName!.sha256 : qrData.leaf_engFamilyName) ?? "")
                pi_node_1 += (((qrData.engGivenName != nil) ? qrData.engGivenName!.sha256 : qrData.leaf_engGivenName) ?? "")
                pi_node_1 += (((qrData.engGivenNameFirstLetter != nil) ? qrData.engGivenNameFirstLetter!.sha256 : qrData.leaf_engGivenNameFirstLetter) ?? "")
                pi_node_1 += (((qrData.idPhoto != nil) ? qrData.idPhoto?.sha256 : qrData.leaf_idPhoto) ?? "")
                print(qrData.idPhoto)
                pi_node_1 += (((qrData.idPhotoHash != nil) ? qrData.idPhotoHash! : qrData.leaf_idPhotoHash) ?? "")
                print(pi_node_1)
                qrhashPI += pi_node_1.sha256
            } else {
                qrhashPI += qrData.PI_node_1!
            }
            print(qrhashPI)
            if  qrData.PI_node_2 == nil || qrData.PI_node_2 == "" {
                var pi_node_2 = (((qrData.docType != nil) ? qrData.docType!.sha256 : qrData.leaf_docType) ?? "")
                pi_node_2 += (((qrData.docNumber != nil) ? qrData.docNumber!.sha256 : qrData.leaf_docNumber) ?? "")
                pi_node_2 += (((qrData.docNumberFirstHalf != nil) ? qrData.docNumberFirstHalf!.sha256 : qrData.leaf_docNumberFirstHalf) ?? "")
                pi_node_2 += (((qrData.docNumberSecondHalf != nil) ? qrData.docNumberSecondHalf!.sha256 : qrData.leaf_docNumberSecondHalf) ?? "")
                pi_node_2 += (((qrData.passportNumberFirstHalf != nil) ? qrData.passportNumberFirstHalf!.sha256 : qrData.leaf_passportNumberFirstHalf) ?? "")
                pi_node_2 += (((qrData.passportNumberSecondHalf != nil) ? qrData.passportNumberSecondHalf!.sha256 : qrData.leaf_passportNumberSecondHalf) ?? "")
                pi_node_2 += (((qrData.mainlandTravelPermitNoFirstHalf != nil) ? qrData.mainlandTravelPermitNoFirstHalf!.sha256 : qrData.leaf_mainlandTravelPermitNoFirstHalf) ?? "")
                pi_node_2 += (((qrData.mainlandTravelPermitNoSecondHalf != nil) ? qrData.mainlandTravelPermitNoSecondHalf!.sha256 : qrData.leaf_mainlandTravelPermitNoSecondHalf) ?? "")
                qrhashPI += pi_node_2.sha256
            } else {
                qrhashPI += qrData.PI_node_2 ?? ""
            }
            print(qrhashPI)
            qrhashPI = qrhashPI.sha256
        } else {
            qrhashPI = qrData.PI_node ?? ""
        }
        
        print(qrhashPI)
        qrhash += qrhashPI
        if qrData.VR_node == nil || qrData.VR_node == "" {
            if  qrData.VR_node_1 == nil || qrData.VR_node_1 == "" {
                var vr_node_1 = (((qrData.vaxName_1 != nil) ? qrData.vaxName_1!.sha256 : qrData.leaf_vaxName_1) ?? "")
                vr_node_1 += (((qrData.lotNumber_1 != nil) ? qrData.lotNumber_1!.sha256 : qrData.leaf_lotNumber_1) ?? "")
                vr_node_1 += (((qrData.vaxDate_1 != nil) ? qrData.vaxDate_1!.sha256 : qrData.leaf_vaxDate_1) ?? "")
                vr_node_1 += (((qrData.vaxLocation_1 != nil) ? qrData.vaxLocation_1!.sha256 : qrData.leaf_vaxLocation_1) ?? "")
                qrhashVR += vr_node_1.sha256
            } else {
                qrhashVR += qrData.VR_node_1 ?? ""
            }
            print(qrhashVR)
            if  qrData.VR_node_2 == nil || qrData.VR_node_2 == "" {
                var vr_node_2 = (((qrData.vaxName_2 != nil) ? qrData.vaxName_2!.sha256 : qrData.leaf_vaxName_2) ?? "")
                vr_node_2 += (((qrData.lotNumber_2 != nil) ? qrData.lotNumber_2!.sha256 : qrData.leaf_lotNumber_2) ?? "")
                vr_node_2 += (((qrData.vaxDate_2 != nil) ? qrData.vaxDate_2!.sha256 : qrData.leaf_vaxDate_2) ?? "")
                vr_node_2 += (((qrData.vaxLocation_2 != nil) ? qrData.vaxLocation_2!.sha256 : qrData.leaf_vaxLocation_2) ?? "")
                qrhashVR += vr_node_2.sha256
            } else {
                qrhashVR += qrData.VR_node_2 ?? ""
            }
            print(qrhashVR)
            qrhashVR = qrhashVR.sha256
            print(qrhashVR)
        } else {
            qrhashVR = qrData.VR_node ?? ""
        }
        qrhash += qrhashVR
        print(qrhash)
        print("_______________________")
        
        return qrhash.sha256
        
    }
}

