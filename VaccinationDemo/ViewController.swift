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
                }
            }
            if let mtpnf = root.child(withType: .MTPNF) {
                if mtpnf.isNeedsHash == false {
                    let mtpnl = root.child(withType: .MTPNL)
                    mtpnl?.needsHashFlags = false
                }
                
            }
            
            if let photoHash = root.child(withType: .PID_hash){
                photoHash.needsHashFlags = false
            }
            root.calcHashValue()
            
            qrCodeButton.isHidden = true
            
            customButton.isHidden = true
            
//            qrCodeView.show(on: self.view)
            qrCodeView.show()
            // pass different json string to the view
            //
            
            print(root.jsonString())
            let jsonData = appendRoot(qrDataStr: root.jsonString()).data(using: .utf8)!
            var qrJson: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
            let output_str = appendRoot(qrDataStr: root.jsonString())
            if  (qrJson.VR_node != nil || qrJson.VR_node_2 != nil || qrJson.leaf_vaxDate_2 != nil) {
                ///  Call BulletProofs
                ///
                
                print(root.child(withType: .SVD)?.value)
                let test_code = "\"hiddenDayRanage\":\"2021-12 to 2022-02\",\"proof\":\"{\"Comms\":[{\"X\":3222654637875192745354454637973036532595341880121099766536997021842421352519,\"Y\":87752970084526618447268815289431646744297629389102585223773095933046099785686}],\"A\":{\"X\":109179711680089988695004171704384611884115061843269329710516277828489784865544,\"Y\":11940522885640250030387594598984162757619916786034649991546831946111248196660},\"S\":{\"X\":64897008952065266308599592764047024273193267354681351811956244820464128190727,\"Y\":55592098415775098989430603952747501685800408108409067987392759608829181768275},\"T1\":{\"X\":85490653558986223843458112169790813561431729380421206500473822321608870294841,\"Y\":64284023172455015334609561186795475327487978417597664887898989961591682094045},\"T2\":{\"X\":96645574368066047203664165454224712369618168371520585022269554799143004574888,\"Y\":77093838799222865909557329842991321198860617449935217671395441592210285618369},\"Tau\":108993149889797579449354737284525933485536937399356319606958549722639199342722,\"Th\":35195034540034631359455656169511322611963982135101594522982865393942282309158,\"Mu\":45463480417425604640677453725533782590845449768840076309111005873128189317702,\"IPP\":{\"L\":[{\"X\":15074779018040410462089023536957943048029002906820702869265647536643057325060,\"Y\":47736005371789723864272634690346888987794437477963376324560008494474829857900},{\"X\":79037455133670491481266642230139737478920797882859637940300781924501400394951,\"Y\":76741319728838357877897929296137139951936543899284681739839062366066895981426},{\"X\":11738399144349417417994834787327803259576539205135135338076987070217364475395,\"Y\":104404744580611303029165347575085404296102226253152433856475688135935196962872}],\"R\":[{\"X\":11229341690739833120777001375937488702228637688712938142896255245162055230832,\"Y\":100271358052988650731174360902603228087584293318157216977965619873107118428088},{\"X\":9976473484203052657087255187941515928900062510035482953648029453650189408623,\"Y\":98494951343223753222710633475199117307259329088495477506912776981082827735091},{\"X\":85560936977390777292792699165600599306122554435637431007192317154120840511326,\"Y\":99416757270783951603874703893683045156944085768998513414442149077147203003875}],\"A\":17787865516594481254084065772482083775556387741633075248421243520112534107384,\"B\":30847791129860729583821868271967925251013183236584751152676701067138333164746,\"Challenges\":[84630329247400697049015266853554985118578836400781490927437144862495049651520,17385808897702089225987102895006824760674730279609366769852724573479311573537,23336435443182218243228846505799141291366032025541376639337784020191916781733,58327272387600398298263728869942650157949459187593271517527347875046124620827]},\"Cy\":99085142134883790465064899595574696967869045532707536963047933764361302897263,\"Cz\":103749386385159896551132148246366342125058546256102282431442069672335739138642,\"Cx\":60360768390778476355237890352598189406490959080146319631375513191531042682829}\""
                print(test_code)
                qrCodeView.generateQRCode(value: test_code+output_str)
            } else {
                qrCodeView.generateQRCode(value: output_str)
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
            
            qrCodeView.show()
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
        if  (qrJson.VR_node != nil || qrJson.VR_node_2 != nil || qrJson.leaf_vaxDate_2 != nil) {
            ///  Call BulletProofs
            let test_code = "{\"Comms\":[{\"X\":55590440623740606199674098809656112161487492979619741217650431088621478732182,\"Y\":41627569468450806916441419466913955568848827531711969450650208548865003764233},{\"X\":24436294515104313780262302420645255829689290054269031797535530114498945449940,\"Y\":16337110931067283213342147383238650775485512947953395818809530975286640171339}],\"A\":{\"X\":43963089307761763091813994912083218884908193262097953554887677910826405310508,\"Y\":6681284843259933729407884905567113614383448162780842852098258713370857714340},\"S\":{\"X\":17156015590498521814047890709911164550870590781505470189266838854665960460253,\"Y\":92553411519277736769620356948189430873911197170405431608437272175996163119636},\"T1\":{\"X\":94036609118225702211327107709985004692715922081624263589106211520103354650332,\"Y\":74643378952680652577800989105415881753836073389111661659705441710242908797252},\"T2\":{\"X\":58924007892978057061085339581215235419158010417200817818880065970461861680593,\"Y\":72956323667056177865077336901465228202495402163917144677207152456466819444863},\"Tau\":8992000028075564584797175351489479825883927898830450639005756818130884590855,\"Th\":83005697418117722806561714714524672619650608933308902753609616662496610930293,\"Mu\":100823811596948512182883596778530381716454771148952357743490122413145262461220,\"IPP\":{\"L\":[{\"X\":60985283119660640334005104185146921063767351294011161885397882524117471448878,\"Y\":88317102702961552507888646879233125557306304598480214909243665025622647854500},{\"X\":78721462848878806936770790574475120333686873951868238622695301743329428894758,\"Y\":100426856561089269227708862033329169090135360681867733259083296091779969073195},{\"X\":7237129569154125138186321049960177721401636113663983960234751798923793620095,\"Y\":43703398902676955400529063122439972809905188257525154145311598476469839099185},{\"X\":18621555777457435692317799306911114552930850911588427698279536312391125938002,\"Y\":62552331817552270758745590677911094327169506885401164327438592444564496155358}],\"R\":[{\"X\":31048731483064658667841468788414573589862833314798388862269219872943907261187,\"Y\":56795061264089138149248297015265067202192359433173889724621809004052017193804},{\"X\":81401152503609816849537672478608110497287934542784693366445583785726202130299,\"Y\":63160181162926403950261789504789836011758670844740137384976525295084355408690},{\"X\":72490510210724728102707264475645711836266542438546134057488915636317930802290,\"Y\":27247887899805297592129914259196533539849135198977784368252799270935060304599},{\"X\":1663856520820352507484522753169472075708336233612874489815528181756869743846,\"Y\":79030861566766860405096118248599808397999431486125586688899045735506359250426}],\"A\":1835425837960319059247373834517120718329519897899659870853636186581725532462,\"B\":17868810310056080283849276499476916498963429635889659542606722977291389777776,\"Challenges\":[49686254986642104618503382262961957646312408012364809393072318207310301987578,14406555623780341350305070236909650698156237372112303502188052304839974812305,53328093531398025467342875070068810312286152906320294207326411092586521186086,15013189596740826681476540568784380195175600868050980153238447725334357431368,53927537120274833822513110243872419990124796497663892345750923002006003795414]},\"Cy\":38644862766655323004701318234585550724283760099831164772204002692217025493233,\"Cz\":92396358519609824067193234595131955802571469035501462285293429900376652479854,\"Cx\":65946017439100690632203547417636481999878601264780584485128234394374110883091}"
            print(test_code)
            qrCodeView.generateQRCode(value: test_code+output_str)
        } else {
            qrCodeView.generateQRCode(value: output_str)
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

