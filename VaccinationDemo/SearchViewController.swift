//
//  SearchViewController.swift
//  VaccinationDemo
//
//  Created by Comp 631C on 25/5/2021.
//  Copyright © 2021 guofeng. All rights reserved.


import Foundation
import UIKit
//import SQLite
import QRCodeReader
import SwiftyRSA

struct QRJson: Decodable {
//    enum Category: String, Decodable {
//        case swift, combine, debugging, xcode
//    }
//    let NTR:String?
//    let ISCD:String?
//    let EGN:String?
//    let FVD:String?
//    let ITR:String?
//    let FVP:String?
//    let NSCD:String?
//    let FVN:String?
//    let FVLN:String?
//    let SVD:String?
//    let SVP:String?
//    let SVN:String?
//    let DT:String?
//    let SVLN:String?
//    let EFN:String?
//    let DN:String?
//    let PI_1_0:String?
//    let Test_1_2:String?
//    let CFN:String?
//    let CGN:String?
    var ScanTime:Date?
    var validFlag: Bool?
    
    
     var engFamilyName:String?
     var engGivenName:String?
     var engGivenNameFirstLetter:String?
     var docType:String?
     var docNumber:String?
     var docNumberFirstHalf:String?
     var docNumberSecondHalf:String?
     var vaxName_1:String?
     var lotNumber_1:String?
     var vaxDate_1:String?
     var vaxLocation_1:String?
     var vaxName_2:String?
     var lotNumber_2:String?
     var vaxDate_2:String?
     var vaxLocation_2:String?
    
    var leaf_engFamilyName:String?
     var leaf_engGivenName:String?
     var leaf_engGivenNameFirstLetter:String?
     var leaf_docType:String?
     var leaf_docNumber:String?
     var leaf_docNumberFirstHalf:String?
     var leaf_docNumberSecondHalf:String?
     var leaf_vaxName_1:String?
     var leaf_lotNumber_1:String?
     var leaf_vaxDate_1:String?
     var leaf_vaxLocation_1:String?
     var leaf_vaxName_2:String?
     var leaf_lotNumber_2:String?
     var leaf_vaxDate_2:String?
     var leaf_vaxLocation_2:String?

     var PI_node:String?
     var VR_node:String?
    
     var PI_node_1:String?
     var PI_node_2:String?
     var VR_node_1:String?
     var VR_node_2:String?

     
}

class SearchViewController: UITableViewController, QRCodeReaderViewControllerDelegate {
    
    let defaults = UserDefaults.standard
    @IBOutlet var tableview:UITableView!
    let cellReuseIdentifier = "qrRecordCell"
    
    // Chan Tai Man
//    let testingRootHash = "cae205b9e2e59603f8a47681bab22f77689dddcaa1ff3be62fb040a056555c5c"
    
    // Chan Siu Man
    let testingRootHash = "151dc20e365a1c90ae004172f528f7d140931ce73815995b4d46983f4d098e13"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        // Register the table view cell class and its reuse id
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
//        print( getRootHash ())
//        verifyDataTest()
    }
    
//    private func getRootHash () ->String{
//        var string = ""
//        do{
//            let key = try PrivateKey(data:"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDLlmmVLUmtUn5PQAXribP4MT2IImkYZNCd+k0mxFcnaBcf3NXYbYrbxl4Zws+qpPmU+9PndtuRtoee8tthwlG2D/w2JMDmn7A6kPc4iZVK91wf49lTRZYESM889JNK8KAvT2ZMkSD845N5p3MWIPe8MiWyT44M3z/0w3MxaPYVxqvN0AytEr6QTdgZhCtkxzrkIHPY97fR5QlGGlkAx389JjX2/SfhHv7K8mEQxM/M6U2kAZA0aUWSJbBs1sDdmlVSwKVuEQEY8dnys79aCgX/1nvAtVYNHnPdkSo3nQphdNw7mVqXQM75piTnouyf/mn7RtCR+GxpE63rWO/n2UEDAgMBAAECggEAGNuatK486r7B0Wdd0a6UnN9WRgL9lg7pMgDX3r3mbldVS3ypV624YLFN2BNjS9Cs8LX237IxiQ8ibBP3GW6ij3pQL0Q5kW86E0yUAwE5i1e8leA6LuK2OHuzYhvyyBmtVVl6girOPlKDNT1u3erUlNQCqkzwaT3xDy+2JvhL48iQeTDqrzPJplUkCiNDmbODrgVQ0Bk/IhTQLkOvT6z/McxrkmFTLSF+qM59lAvJMl1F9BGzu6djRwArdSUlP3PNKIqg4laR7SgJ3dBtj0lzyy9Yc4sIugbVJI+hVJHDUsOUmZ1/qejPWOx7bb/Rt/SwBn3It97XRpn40JW4qZ+WcQKBgQDqFqOfRStmUfmx290HkTFScy30bJ4rjs8+rZdmTPzQgC8Ug8xni3y/wrzvy0IbKYJWWSqT/5D8RfyLUVj89O02TV8m8fQCnnnIa/X75eoWAt4mRlU9nvIt9BY43Y1IL73ITLDcmaP/IQUO81zAsssmf0jREnGHeKNJHFf4isVZFQKBgQDepOTE7qOO8imWjkuF8nRFrkasjPrP6iYptJrT4eoSJNLfM28FnVafs8buBe5JddSf2OUyKmEuqvBP/6ORNuUm0Ou3yJdzcy0L5oQR6DktM1HsUunoiVD2ZjltN+xQmxFhMAptPuzQ0II79ArPu5mCuhARGtSIwZAVpIBRibsHtwKBgQCGErFkZ5mT4R/CXssZqm81agLIG+37xK+uln5AeZfTU5ejiFlqdNneewr7zM7v/7ZG/osEeTvxQaSDpvPw7ddvYqE9DRdU6K+Xuz4IKIcKVFooUeBAiujqqQKRT1O8JJvuPP6PWvAzEBZ1ma1mMQFp6z0pggbEMLRVC4bXM6QUgQKBgQCAs1j67efmLd4UhdTqbSkBTqjT/frOTVAaM6h8as9gBaFQHO9Ek5sLXmTUGuGP3Wk3ra1vvkfHLlEULXZj7xOvyH06E95Ygm+7vVkC8PZ8RnpI3fUQ0q/Wf2ka1YTpY3o8cATW+dTzMFTYS04knxEyHFRFTvkkxJ+Bo0H54GAZKQKBgFC8ZDX+nV7mTzjFz+6UH3i/tHpRWULH90e/yWpM/+wmDEaPeIN8k95nMnTEw0sskDkvum7QDmyKf9oaQHjgPhNpbWGar9W/CpsnIBI96Lb8wj/7OVb99fh4cgkZRyS5HWT0MEyu4WlWj32HAfkOIRLIn831HbCu63Uj8RSoBj1p".data(using: .utf8)!)
//        let encrypted = try EncryptedMessage(base64Encoded: "xJtM4wu5N++XvdRcJ4v8kJWSOxOvs6OZ/zVwczsoEL8jliD6jLGytRfgAEwB2/e04HGL86MVMBSVhG3Nco/TgGAmCsHq/yUWC1AHGoTEV6Uq+Ci3ttsbtHtYFYoKdSvxcBiT3niivgcVpVyA+DPyXasTNbe0fTA+H6HqZk8a6xa6KfDJx3e48vI+Cj7LZWGFDKAXKe28ZeOob5zYTWC8hi7jO1K400aC8I2BTP+DAg1RonSMl/BT7kNwf4GRORCR2rQT9o4HRJTyGMSU4vSGhsfy6gs2lDenVvi7WQ/iEGa3sEY143BQBykfAv5YWPHVFJnuiEmJNe3nOTa5o0AgdA==")
//        let clear = try encrypted.decrypted(with: key, padding: .PKCS1)
//        let data = clear.data
//        let base64String = clear.base64String
//            string = try clear.string(encoding: .utf8)
//
//        } catch {
//                print("Decript error")
//        }
//        return string
//    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: 0x256ba9)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.hs_systemFont(size: 22, isBold: true)]
        self.navigationItem.title = "Scan Record"
//        self.title = "iVaxCert"
        
//        let leftItem = UIBarButtonItem(customView: self.cancelButton)
//        self.navigationItem.leftBarButtonItem = leftItem
        
        // add QR scan button on the right
        
//        let rightItem = UIBarButtonItem(customView: self.customButton)
//        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = true
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = true
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    @IBAction func startQRScan(_ sender: Any){
        print("Clicked")
        guard checkScanPermissions() else { return }
        
        // By using the delegate pattern
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate = self

        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
                let jsonData = result.value.data(using: .utf8)!
                do {
                    var qrJson: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
                    print(qrJson.engGivenName)
                    qrJson.ScanTime = Date()
                    qrJson.validFlag =  self.verifyData(qrData: qrJson)
                    print(qrJson.validFlag)
                    if (self.fakeQR(qrJson: qrJson)) {
                        // create the alert
                        print("invalid code")
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Please use a valid QR code", message: nil, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            alert.addAction(cancelAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        if ( self.defaults.object(forKey: "qr_record") != nil) {
                            var arr = self.defaults.object(forKey: "qr_record")as? [String] ?? [String]()
                            arr.append(result.value)
                            self.defaults.set(arr,forKey: "qr_record")

                        }
                        else {
                            var arr = [String]()
                            arr.append(result.value)
                            self.defaults.set(arr,forKey: "qr_record")
                        }
                        self.tableview.reloadData()
    //                    let dataFieldModel = DataFieldModel.createQR(qr: qrJson);
    //                    if ( self.defaults.object(forKey: "qr_record") != nil) {
    //                        var arr = self.defaults.object(forKey: "qr_record")as? [DataFieldModel] ?? [DataFieldModel]()
    //                        arr.append(dataFieldModel)
    //                        self.defaults.set(arr,forKey: "qr_record")
    //
    //                    }
    //                    else {
    //                        var arr = [DataFieldModel]()
    //                        arr.append(dataFieldModel)
    //                        self.defaults.set(arr,forKey: "qr_record")
    //                    }
                        
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
                
            }
        }

        // Presents the readerVC as modal form sheet
        present(readerVC, animated: true, completion: nil)
    }
    
    func fakeQR(qrJson:QRJson) -> Bool {
        if (qrJson.engFamilyName != nil || qrJson.engFamilyName != "" || qrJson.PI_node_1 != nil || qrJson.PI_node_1 != "" || qrJson.PI_node != nil || qrJson.PI_node != "") {
            return false
        }
        return true
    }
    
    public func verifyData(qrData:QRJson) -> Bool{
        // if changed to dynamic array, just check if the 'id_n' is not nil or 'leaf_id_n' is not nil
        var qrhash = ""
        var qrhashPI = ""
        var qrhashVR = ""
        if qrData.PI_node == nil || qrData.PI_node == "" {
            if  qrData.PI_node_1 == nil || qrData.PI_node_1 == "" {
                var pi_node_1 =  (((qrData.engFamilyName != nil) ? qrData.engFamilyName!.sha256 : qrData.leaf_engFamilyName) ?? "")
                pi_node_1 += (((qrData.engGivenName != nil) ? qrData.engGivenName!.sha256 : qrData.leaf_engGivenName) ?? "")
                pi_node_1 += (((qrData.engGivenNameFirstLetter != nil) ? qrData.engGivenNameFirstLetter!.sha256 : qrData.leaf_engGivenNameFirstLetter) ?? "")
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
                qrhashPI += pi_node_2.sha256
            } else {
                qrhashPI += qrData.PI_node_2 ?? ""
            }
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
            qrhashVR = qrhashVR.sha256
        } else {
            qrhashVR = qrData.VR_node ?? ""
        }
        
        qrhash += qrhashVR
        print(qrhash)
        print(self.testingRootHash)
        print(qrhash.sha256)
        print(qrhash.sha256 == self.testingRootHash)
        return (qrhash.sha256 == self.testingRootHash)
//        return true
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( self.defaults.object(forKey: "qr_record") != nil) {
            var arr = self.defaults.object(forKey: "qr_record")as? [String] ?? [String]()
            print(arr.count)
            return arr.count
        } else {
            return 0
        }
            
    }
        
        // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
            
            // set the text from the data model
        if ( self.defaults.object(forKey: "qr_record") != nil) {
            var arr = self.defaults.object(forKey: "qr_record")as? [String] ?? [String]()
//            var index = ((indexPath.row - arr.count)>0)?(indexPath.row - arr.count):((indexPath.row - arr.count)*-1)
            let jsonData = arr[indexPath.row].data(using: .utf8)!
            var qrJson: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
            let dateFormatter = DateFormatter()
            qrJson.validFlag = self.verifyData(qrData: qrJson)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "d/M/Y HH:mm:ss "
            // set the text from the data model
            cell.textLabel!.lineBreakMode = .byWordWrapping
            cell.textLabel!.numberOfLines = 5
            // check pass fail function
            var image : UIImage = UIImage(named: "syringe_yellow.png")!
                        print("The loaded image: \(image)")
            if qrJson.validFlag! == false {
                image  = UIImage(named: "cross_red.png")!
            } else {
                if  (qrJson.vaxDate_2 != nil && qrJson.vaxDate_2 != "" && ifTwoWeek(dateStr:qrJson.vaxDate_2!)){
                    image  = UIImage(named: "syringe_green.png")!
                }
            }
            cell.imageView?.image = image

//            cell.imageView?.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
//            cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            cell.textLabel?.text = dateFormatter.string(from: qrJson.ScanTime ?? Date())
            if qrJson.engGivenNameFirstLetter ?? "" == "" {
                cell.textLabel?.text! += "\n*****"
            } else {
                cell.textLabel?.text! += "\n" + (qrJson.engFamilyName ?? "*****") + ", "
                cell.textLabel?.text! += ((qrJson.engGivenName ?? "" == "") ? (qrJson.engGivenNameFirstLetter ?? "")+"****" : qrJson.engGivenName!)
            }
        }
        
            
        return cell
        }
    func ifTwoWeek(dateStr:String) -> Bool{
        print(dateStr)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MMM-yyyy"
        dateFormatterGet.timeZone = TimeZone(identifier: "Asia/Taipei")
        guard let date = dateFormatterGet.date(from: dateStr)?.addingTimeInterval(1209600) else { return false}
        if (Date() > date){
                    return true
                }
        return false
    }
        // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
            
            self.performSegue(withIdentifier: "ScanDetail", sender: self)
        }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            print("yo")
//            self?.checkin(venueID: result.value)
            //decode QR code

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("Call prepare")
        if segue.identifier == "ScanDetail" {

            let indexPaths=self.tableView!.indexPathsForSelectedRows!

            let indexPath = indexPaths[0] as NSIndexPath

            let vc = segue.destination as! ScanDetailViewController
//            print(indexPath.row)
            vc.detailIndex = indexPath.row

        }

    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReader check Scan Permissions
    private func checkScanPermissions() -> Bool {
      do {
        return try QRCodeReader.supportsMetadataObjectTypes()
        
      } catch let error as NSError {
        let alert: UIAlertController

        switch error.code {
        case -11852:
            alert = UIAlertController(
                    title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Setting", style: .default,
                                handler: { (_) in
                                    DispatchQueue.main.async {
                                      if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                        if #available(iOS 10.0, *) {
                                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                                        } else {
                                            // Fallback on earlier versions
                                        }
                                      }
                                    }
                                }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
        default:
            alert = UIAlertController(title: "Error", message: "Reader not supported by the current device",
                                      preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }

        present(alert, animated: true, completion: nil)

        return false
      }
    }
    
}
