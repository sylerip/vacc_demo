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
import Alamofire

struct QRJson: Codable {
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
    var ScanTime:String?
    var validFlag: Bool?
    
    
     var engFamilyName:String?
     var engGivenName:String?
     var engGivenNameFirstLetter:String?
     var docType:String?
     var docNumber:String?
     var docNumberFirstHalf:String?
     var docNumberSecondHalf:String?
     var idPhoto:String?
     var idPhotoHash:String?
     var passportNumberFirstHalf:String?
     var passportNumberSecondHalf:String?
     var mainlandTravelPermitNoFirstHalf:String?
     var mainlandTravelPermitNoSecondHalf:String?
     
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
     var leaf_idPhoto:String?
     var leaf_idPhotoHash:String?
     var leaf_passportNumberFirstHalf:String?
     var leaf_passportNumberSecondHalf:String?
     var leaf_mainlandTravelPermitNoFirstHalf:String?
     var leaf_mainlandTravelPermitNoSecondHalf:String?
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

     var roothash:String?
    
    var hiddenDayRanage:String?
    var proof:String?
}

class SearchViewController: UITableViewController, QRCodeReaderViewControllerDelegate {
    
    let defaults = UserDefaults.standard
    @IBOutlet var tableview:UITableView!
    let cellReuseIdentifier = "qrRecordCell"
    
    // Chan Tai Man
//    let testingRootHash = "cae205b9e2e59603f8a47681bab22f77689dddcaa1ff3be62fb040a056555c5c"
    
    // Chan Siu Man
//    let testingRootHash = "151dc20e365a1c90ae004172f528f7d140931ce73815995b4d46983f4d098e13"
    
    
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
                    try JSONDecoder().decode(QRJson.self, from: jsonData)
                } catch let error {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Please use a valid QR code", message: nil, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                do {
                    var qrJson: QRJson = try! JSONDecoder().decode(QRJson.self, from: jsonData)
                    
                    
                    print(qrJson.engGivenName)
//                    qrJson.ScanTime = Date()
//                    print("Time :    ")
//                    print(qrJson.ScanTime)
                    self.verifyData(qrData: qrJson, qrStr: result.value)
                    
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
                
            }
        }
        
        // Presents the readerVC as modal form sheet
        present(readerVC, animated: true, completion: nil)
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            var arr = self.defaults.object(forKey: "qr_record")as? [String] ?? [String]()
            let indexPath = IndexPath(row: arr.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func fakeQR(qrJson:QRJson) -> Bool {
        if (qrJson.engFamilyName != nil || qrJson.engFamilyName != "" || qrJson.PI_node_1 != nil || qrJson.PI_node_1 != "" || qrJson.PI_node != nil || qrJson.PI_node != "") {
            return false
        }
        return true
    }
    
    public func verifyData(qrData:QRJson, qrStr: String) {
        // if changed to dynamic array, just check if the 'id_n' is not nil or 'leaf_id_n' is not nil
        // add a while loop and while the id is true contiune
        var qrhash = ""
        var qrhashPI = ""
        var qrhashVR = ""
        if qrData.PI_node == nil || qrData.PI_node == "" {
            if  qrData.PI_node_1 == nil || qrData.PI_node_1 == "" {
                var pi_node_1 =  (((qrData.engFamilyName != nil) ? qrData.engFamilyName!.sha256 : qrData.leaf_engFamilyName) ?? "")
                pi_node_1 += (((qrData.engGivenName != nil) ? qrData.engGivenName!.sha256 : qrData.leaf_engGivenName) ?? "")
                pi_node_1 += (((qrData.engGivenNameFirstLetter != nil) ? qrData.engGivenNameFirstLetter!.sha256 : qrData.leaf_engGivenNameFirstLetter) ?? "")
                pi_node_1 += (((qrData.idPhoto != nil) ? qrData.idPhoto!.sha256 : qrData.leaf_idPhoto) ?? "")
                pi_node_1 += (((qrData.idPhotoHash != nil) ? qrData.idPhotoHash! : qrData.leaf_idPhotoHash) ?? "")
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
//        print(qrhash)
//        print(qrData.rootSignature)
//        print(qrhash.sha256)
//        print(qrhash.sha256 == qrData.rootSignature)
        getRootHash(rootHashCal: qrhash.sha256, qrData: qrData, qrStr:qrStr)
        
//        return (qrhash.sha256 == qrData.rootSignature)
//        return true
        
    }
    struct results: Codable {
        let records: String
    }
    func getRootHash(rootHashCal: String, qrData:QRJson, qrStr:String) {
        let params = [
            "command": "query",
            "id": rootHashCal.sha256
            
        ]
        print("-------------------------------------")
        print(rootHashCal)
        print(rootHashCal.sha256)
        Alamofire.request("http://47.107.127.74/netAPI.php", method: .post, parameters: params).responseJSON { response in
            print("Response--------------------------------")
            var ifvalFlag = false
            switch response.result {
                case .success(let results):
                    print("succes!")
                    print(response)
                    print(rootHashCal)
                    if (String(decoding: response.data!, as: UTF8.self).lowercased().range(of:rootHashCal) != nil) {
//                        return true
                        ifvalFlag = true
                        
                    } else {
                        ifvalFlag = false
                    }
                    
                case .failure(let error):
                    print("Error -------------------")
                    print(error)
                    print(response.response?.statusCode)
                    ifvalFlag = false
                }
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd hh:mm:ss"
            df.timeZone = TimeZone.current
            let now = df.string(from: Date())
            let vflag = ifvalFlag ? "true":"false"
            print(qrStr.replacingOccurrences(of: " }", with: String(", \"ScanTime\": \"" + now + "\", \"validFlag\":"+vflag+"}")))
            print(qrStr);
            if (self.fakeQR(qrJson: qrData)) {
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
//                            arr.append(result.value)
                    
                    arr.append(qrStr.replacingOccurrences(of: " }", with: String(", \"ScanTime\": \"" + now + "\" , \"validFlag\":"+vflag+"}")))
                    self.defaults.set(arr,forKey: "qr_record")

                }
                else {
                    var arr = [String]()
                    
//                            arr.append(result.value)
                    arr.append(qrStr.replacingOccurrences(of: " }", with: String(", \"ScanTime\": \"" + now + "\" , \"validFlag\":"+vflag+"}")))
                    self.defaults.set(arr,forKey: "qr_record")
                }
                self.tableview.reloadData()
                self.scrollToBottom()
                
            }
            print("Response--------------------------------")
        }
        
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
//            qrJson.validFlag = self.verifyData(qrData: qrJson)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "d/M/Y HH:mm:ss "
            // set the text from the data model
            cell.textLabel!.lineBreakMode = .byWordWrapping
            cell.textLabel!.numberOfLines = 5
            // check pass fail function
            var image : UIImage = UIImage(named: "syringe_yellow.png")!
                        print("The loaded image: \(image)")
            if (qrJson.validFlag ?? true) == false {
                image  = UIImage(named: "cross_red.png")!
            } else {
                if  ((qrJson.vaxDate_2 != nil && qrJson.vaxDate_2 != "" && ifTwoWeek(dateStr:qrJson.vaxDate_2!)) || ifDateProofed(dateRanage: qrJson.hiddenDayRanage ?? "",proofStr: qrJson.proof ?? "")){
                    image  = UIImage(named: "syringe_green.png")!
                }
            }
            cell.imageView?.image = image

//            cell.imageView?.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
//            cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            print(qrJson.ScanTime)
            cell.textLabel?.text = qrJson.ScanTime ?? "***"
//            cell.textLabel?.text = qrJson.vaxDate_2 ?? qrJson.hiddenDayRanage
            if qrJson.engFamilyName ?? "" == "" {
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
//        dateFormatterGet.dateFormat = "dd-MMM-yyyy"
        dateFormatterGet.dateFormat = "yyyy-mm-dd"
        dateFormatterGet.timeZone = TimeZone(identifier: "Asia/Taipei")
        guard let date = dateFormatterGet.date(from: dateStr)?.addingTimeInterval(1209600) else { return false}
        if (Date() > date){
                    return true
                }
        return false
    }
    func ifDateProofed(dateRanage:String, proofStr:String) -> Bool{
        let str = proofStr.replacingOccurrences(of: "'", with: "\"")
        if (BulletProofs.proofDate(str)) {
            return true
        } else {
            return false
        }
    }
        // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
            
            self.performSegue(withIdentifier: "ScanDetail", sender: self)
        }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
//            print("yo")
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
