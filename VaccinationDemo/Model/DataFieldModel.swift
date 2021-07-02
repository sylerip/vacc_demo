//
//  DataFieldModel.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/3.
//  Copyright © 2021 guofeng. All rights reserved.
//

import Foundation
import UIKit

class DataFieldModel {
    private(set) var uuid: String
    
    ///字段类型
    var fieldType: DataFieldType
    
    ///字段值（Bool类型用0或1表示 -- 0: false, 1: true）
    var value: String = ""
    
    ///日期
    var date: Date? {
        didSet {
            if date != nil {
                if value.isEmpty {
                    value = VaccDateFormatter.string(from: date!)
                }
                
                if needsHashFlags {
                    needsHashFlags = false
                }
            }
        }
    }
    
    var dateStyle: DateStyle = .exact {
        didSet {
            guard let `date` = date else { return }
            needsHashFlags = true
            switch dateStyle {
            case .exact:
                value = VaccDateFormatter.string(from: date)
                needsHashFlags = false
            case .week:
                var timeInterval = date.timeIntervalSince1970
                timeInterval -= 3600.0 * 24 * 7
                let start = Date.init(timeIntervalSince1970: timeInterval)
                value = "\(VaccDateFormatter.string(from: start)) - \(VaccDateFormatter.string(from: date))"
                needsHashFlags = false
            case .month:
                var timeInterval = date.timeIntervalSince1970
                timeInterval -= 3600.0 * 24 * 30
                let start = Date.init(timeIntervalSince1970: timeInterval)
                value = "\(VaccDateFormatter.string(from: start)) - \(VaccDateFormatter.string(from: date))"
                needsHashFlags = false
            case .hide:
                value = VaccDateFormatter.string(from: date)
                
            }
        }
    }
    
    ///随机数
    var random: String = ""
    
    ///hash标志
    var needsHashFlags: Bool = true
    
    ///hash值
    var hashValue: String = ""
    
    ///子节点
    lazy var children: [DataFieldModel] = [DataFieldModel]()
    
    ///是否需要hash
    var isNeedsHash: Bool {
        var ret = needsHashFlags
        if ret && children.count > 0 {
            for child in children {
                ret = child.isNeedsHash
                if !ret {
                    return ret
                }
            }
        }
        return ret
    }
    
    lazy var address: String = {
        let address = Unmanaged<AnyObject>.passUnretained(self).toOpaque()
        return String.init(describing: address)
    }()
    
    init(type: DataFieldType) {
        self.fieldType = type
        self.uuid = UUID()
    }
    
    ///计算hash值
    func calcHashValue() {
        if children.count == 0 {
            if needsHashFlags {
//                hashValue = (value.sha256 + random.sha256).sha256
                hashValue = value.sha256
            } else {
                hashValue = ""
            }
        } else {
            var jointHashValue = ""
            for child in children {
                child.calcHashValue()
                jointHashValue += child.hashValue
            }
            
            if isNeedsHash {
                hashValue = jointHashValue.sha256
            } else {
                hashValue = ""
            }
        }
    }
    
//    ///转dictionary
//    func dictionary() -> [String: Any] {
//        var dic = [String: Any]()
//
//        dic["fieldType"] = fieldType.fieldName()
//        dic["value"] = ""
//        dic["hashValue"] = hashValue
//
//        if hashValue.isEmpty {
//            if (children.count > 0) {
//                var array = [[String: Any]]()
//                for child in children {
//                    array.append(child.dictionary())
//                }
//                dic["children"] = array
//            } else {
//                if !needsHashFlags {
//                    dic["value"] = value
//                }
//            }
//        }
//
//        return dic
//    }
    
    ///转dictionary
    func dictionary() -> [String: Any] {
        var dic = [String: Any]()
        
        if !hashValue.isEmpty {
            dic["root"] = hashValue
            return dic
        }
        
        if fieldType != .Parent {
            dic[fieldType.fieldName()] = value
            return dic
        }
        
//        let piSet: Set<DataFieldType> = [.CFN, .CGN, .EFN, .EGN, .DT, .DN]
        let piSet: Set<DataFieldType> = [.EFN, .EGN,.EGNF, .DT, .DN , .DNF, .DNL, .PNF, .PNL, .MTPNF, .MTPNL, .PID, .PID_hash]
        let vaxSet: Set<DataFieldType> = [.FVN, .FVLN, .FVD, .FVP, .SVN, .SVLN, .SVD, .SVP]
        let testSet: Set<DataFieldType> = [.NSCD, .NTR, .ISCD, .ITR]
        
        for child in children {
            var key = ""
            let leaf = child.leaf()
            if piSet.contains(leaf.fieldType) {
                key = "PI_node"
            } else if vaxSet.contains(leaf.fieldType) {
                key = "VR_node"
            } else if testSet.contains(leaf.fieldType) {
                key = "Test_node"
            }
            
            if !key.isEmpty {
                dic = _dictionary(dic: dic, field: child, key: key, level: 0, index: 0)
            }
        }
        
        return dic
    }
    private func _dictionary(dic: [String: Any], field: DataFieldModel, key: String, level: Int, index: Int) -> [String: Any] {
        var `dic` = dic
        if !field.hashValue.isEmpty || field.fieldType != .Parent {
            var _value = field.hashValue
            if _value.isEmpty {
                _value = field.value
            }
            // change this parts to add "leaf_" at the beginning
            
            var `key` = key
            if field.fieldType != .Parent {
                key = (field.needsHashFlags ? "leaf_":"") + field.fieldType.fieldName()
            } else {
                if level == 0 {
                    key += ""
                } else {
                    key += "_\(index+1)"
                }
//                key += "_\(index+1)"
            }
            
            if dic[key] == nil {
                dic[key] = _value
            }
        } else {
            for i in 0..<field.children.count {
                dic = _dictionary(dic: dic, field: field.children[i], key: key, level: level + 1, index: i)
            }
        }
        
        return dic
    }
    
    ///转json字符串
    func jsonString() -> String {
        let json = JSON(dictionary())
        let ret = json.rawString(options: .fragmentsAllowed)
        //let ret = json.rawString()
        return ret ?? ""
    }
    
//    func jsonToObj()->DataFieldModel{
//        var qrmodel:DataFieldModel?
//        
//        return qrmodel!
//    }
}

extension DataFieldModel {
    func findFieldWithUUID(_ uuid: String) -> DataFieldModel? {
        var ret: DataFieldModel?
        if self.uuid == uuid {
            ret = self
        } else {
            for c in children {
                if let field = c.findFieldWithUUID(uuid) {
                    ret = field
                    break
                }
            }
        }
        
        return ret
    }
    
    func child(withType type: DataFieldType) -> DataFieldModel? {
        var ret: DataFieldModel?
        
        if fieldType.rawValue == type.rawValue {
            ret = self
        } else {
            for c in children {
                if let field = c.child(withType: type) {
                    ret = field
                    break
                }
            }
        }
        
        return ret
    }
    
    func parent(withSubType subtype: DataFieldType, parent: DataFieldModel? = nil) -> DataFieldModel? {
        var ret: DataFieldModel?
        
        if fieldType.rawValue == subtype.rawValue {
            ret = parent
        } else {
            for c in children {
                if let field = c.parent(withSubType: subtype, parent: self) {
                    ret = field
                    break
                }
            }
        }
        
        return ret
    }
    
    func parent(withField field: DataFieldModel, parent: DataFieldModel? = nil) -> DataFieldModel? {
        var ret: DataFieldModel?
        
        if self == field {
            ret = parent
        } else {
            for c in children {
                if let field = c.parent(withField: field, parent: self) {
                    ret = field
                    break
                }
            }
        }
        
        return ret
    }
    
    func leaf() -> DataFieldModel {
        var ret = self
        
        if children.count > 0 {
            ret = children[0].leaf()
        }
        
        return ret
    }
}

extension DataFieldModel {
    static func ==(lhs: DataFieldModel, rhs: DataFieldModel?) -> Bool {
        if lhs.address != rhs?.address {
            return false
        } else {
            return true
        }
    }
    
    static func !=(lhs: DataFieldModel, rhs: DataFieldModel?) -> Bool {
        if lhs.address != rhs?.address {
            return true
        } else {
            return false
        }
    }
}

extension DataFieldModel {
    class func getIDPhoto() -> String {
        
        return ""
    }
    class func createTestRoot() -> DataFieldModel {
        let root = DataFieldModel(type: .Parent)
        
        root.children.append(personalNode())
        root.children.append(recordsNode())
//        root.children.append(testResultsNode())
        
        return root
    }
    private class func hs_random() -> String {
        return "\(RandomNumber(from: 100, to: 999))"
    }
    private class func personalNode() -> DataFieldModel {
        let defaults = UserDefaults.standard
        
        let parent = DataFieldModel(type: .Parent)
        
//        let sub0 = DataFieldModel(type: .Parent)
//        let sub0_0 = DataFieldModel(type: .CFN)
//        sub0_0.value = "朱"
//        sub0_0.random = hs_random()
//        let sub0_1 = DataFieldModel(type: .CGN)
//        sub0_1.value = "健康"
//        sub0_1.random = hs_random()
//
//        sub0.children.append(sub0_0)
//        sub0.children.append(sub0_1)
        
        let sub1 = DataFieldModel(type: .Parent)
        let sub1_0 = DataFieldModel(type: .EFN)
        if (defaults.string(forKey: "EFN") != nil) {
            sub1_0.value = defaults.string(forKey: "EFN")!
        } else {
            sub1_0.value = "Chan"
            defaults.set(sub1_0.value,forKey: "EFN")
        }
        
        sub1_0.random = hs_random()
        let sub1_1 = DataFieldModel(type: .EGN)
        if (defaults.string(forKey: "EGN") != nil) {
            sub1_1.value = defaults.string(forKey: "EGN")!
        } else {
            sub1_1.value = "Tai Man"
            defaults.set(sub1_1.value,forKey: "EGN")
        }
        sub1_1.random = hs_random()
        
        let sub1_2 = DataFieldModel(type: .EGNF)
        if (defaults.string(forKey: "EGN") != nil) {
            sub1_2.value = String(defaults.string(forKey: "EGN")!.prefix(1))
        } else {
            sub1_2.value = "T"
//            defaults.set(sub1_1.value,forKey: "EGN")
        }
        sub1_2.random = hs_random()
        
        let sub1_3 = DataFieldModel(type: .PID)
        sub1_3.value = "https://icons-for-free.com/download-icon-boy+guy+man+icon-1320166733913205010_128.png"
        sub1_3.random = hs_random()
        
        let sub1_4 = DataFieldModel(type: .PID_hash)
        let url = URL(string: sub1_3.value)
        let data = try? Data(contentsOf: url!)
        let imgBase64 = data?.base64EncodedString(options: .lineLength64Characters)
        sub1_4.value = imgBase64?.sha256 ?? UIImage(named: "user.png")?.pngData()?.base64EncodedString(options: .lineLength64Characters).sha256 as! String
        sub1_4.random = hs_random()
        
        sub1.children.append(sub1_0)
        sub1.children.append(sub1_1)
        sub1.children.append(sub1_2)
        sub1.children.append(sub1_3)
        sub1.children.append(sub1_4)
        
        let sub2 = DataFieldModel(type: .Parent)
        let sub2_0 = DataFieldModel(type: .DT)
        sub2_0.value = "HKID"
        sub2_0.random = hs_random()
        let sub2_1 = DataFieldModel(type: .DN)
        sub2_1.value = "M123456(1)"
        sub2_1.random = hs_random()
        
        let sub2_2 = DataFieldModel(type: .DNF)
        sub2_2.value = "M123"
        sub2_2.random = hs_random()
        let sub2_3 = DataFieldModel(type: .DNL)
        sub2_3.value = "456(1)"
        sub2_3.random = hs_random()
        
        let sub2_4 = DataFieldModel(type: .PNF)
        sub2_4.value = "P1234"
        sub2_4.random = hs_random()
        let sub2_5 = DataFieldModel(type: .PNL)
        sub2_5.value = "12345"
        sub2_5.random = hs_random()
        let sub2_6 = DataFieldModel(type: .MTPNF)
        sub2_6.value = "P5678"
        sub2_6.random = hs_random()
        let sub2_7 = DataFieldModel(type: .MTPNL)
        sub2_7.value = "56789"
        sub2_7.random = hs_random()
        
        sub2.children.append(sub2_0)
        sub2.children.append(sub2_1)
        sub2.children.append(sub2_2)
        sub2.children.append(sub2_3)
        sub2.children.append(sub2_4)
        sub2.children.append(sub2_5)
        sub2.children.append(sub2_6)
        sub2.children.append(sub2_7)
        
//        parent.children.append(sub0)
        parent.children.append(sub1)
        parent.children.append(sub2)
        
        return parent
    }
    private class func recordsNode() -> DataFieldModel {
        let parent = DataFieldModel(type: .Parent)
        
        let sub0 = DataFieldModel(type: .Parent)
        let sub0_0 = DataFieldModel(type: .FVN)
        sub0_0.value = "CoronaVac COVID-19 Vaccine (Vero Cell), Inactivated"
        sub0_0.random = hs_random()
        let sub0_1 = DataFieldModel(type: .FVLN)
        sub0_1.value = "A2021010011"
        sub0_1.random = hs_random()
        let sub0_2 = DataFieldModel(type: .FVD)
        sub0_2.value = "26-Mar-2021"
        sub0_2.date = VaccDateFormatter.date(from: sub0_2.value)
        sub0_2.random = hs_random()
        let sub0_3 = DataFieldModel(type: .FVP)
        sub0_3.value = "Community Vaccination Centre, Yuen Wo Road Sports Centre"
        sub0_3.random = hs_random()
        
        sub0.children.append(sub0_0)
        sub0.children.append(sub0_1)
        sub0.children.append(sub0_2)
        sub0.children.append(sub0_3)
        
        let sub1 = DataFieldModel(type: .Parent)
        let sub1_0 = DataFieldModel(type: .SVN)
        sub1_0.value = "CoronaVac COVID-19 Vaccine (Vero Cell), Inactivated"
        sub1_0.random = hs_random()
        let sub1_1 = DataFieldModel(type: .SVLN)
        sub1_1.value = "A2021010022"
        sub1_1.random = hs_random()
        let sub1_2 = DataFieldModel(type: .SVD)
        sub1_2.value = "26-Apr-2021"
        sub1_2.date = VaccDateFormatter.date(from: sub1_2.value)
        sub1_2.random = hs_random()
        let sub1_3 = DataFieldModel(type: .SVP)
        sub1_3.value = "Community Vaccination Centre, Yuen Wo Road Sports Centre"
        sub1_3.random = hs_random()
        
        sub1.children.append(sub1_0)
        sub1.children.append(sub1_1)
        sub1.children.append(sub1_2)
        sub1.children.append(sub1_3)
        
        parent.children.append(sub0)
        parent.children.append(sub1)
        
        return parent
    }
    private class func testResultsNode() -> DataFieldModel {
        let parent = DataFieldModel(type: .Parent)
        
        let sub0 = DataFieldModel(type: .Parent)
        let sub0_0 = DataFieldModel(type: .NSCD)
        sub0_0.value = "13 Jan 2021"
        sub0_0.date = VaccDateFormatter.date(from: sub0_0.value)
        sub0_0.random = hs_random()
        let sub0_2 = DataFieldModel(type: .NTR)
        sub0_2.value = "1"
        sub0_2.random = hs_random()
        
        sub0.children.append(sub0_0)
        sub0.children.append(sub0_2)
        
        let sub1 = DataFieldModel(type: .Parent)
        let sub1_0 = DataFieldModel(type: .ISCD)
        sub1_0.value = "13 Jan 2021"
        sub1_0.date = VaccDateFormatter.date(from: sub1_0.value)
        sub1_0.random = hs_random()
        let sub1_2 = DataFieldModel(type: .ITR)
        sub1_2.value = "0"
        sub1_2.random = hs_random()
        
        sub1.children.append(sub1_0)
        sub1.children.append(sub1_2)
        
        let sub2 = DataFieldModel(type: .Parent)
        let sub2_0 = DataFieldModel(type: .NSCD)
        sub2_0.value = "29 Dec 2020"
        sub2_0.date = VaccDateFormatter.date(from: sub2_0.value)
        sub2_0.random = hs_random()
        let sub2_2 = DataFieldModel(type: .NTR)
        sub2_2.value = "1"
        sub2_2.random = hs_random()
        
        sub2.children.append(sub2_0)
        sub2.children.append(sub2_2)
        
        parent.children.append(sub0)
        parent.children.append(sub1)
        parent.children.append(sub2)
        
        return parent
    }
}
extension DataFieldModel {
    class func createQR(qr:QRJson) -> DataFieldModel {
        // modification to need QR
        // id the unhased is not there dirrect st to '*****'
        // add a flag for if verified in the note
        let newNote = DataFieldModel(type: .Parent)
        
        newNote.children.append(qrPersonalNode(qr: qr))
        newNote.children.append(qrRecordsNode(qr: qr))
//        newNote.children.append(qrTestResultsNode(qr: qr))
        
        return newNote
    }
    
    private class func qrPersonalNode(qr:QRJson) -> DataFieldModel {
        let parent = DataFieldModel(type: .Parent)
        
        let sub0 = DataFieldModel(type: .Parent)
//        let sub0_0 = DataFieldModel(type: .CFN)
//        sub0_0.value = qr.chiFamily ?? ""
//        sub0_0.random = hs_random()
//        let sub0_1 = DataFieldModel(type: .CGN)
//        sub0_1.value = qr.CGN ?? ""
//        sub0_1.random = hs_random()
//
//        sub0.children.append(sub0_0)
//        sub0.children.append(sub0_1)
        
        let sub1 = DataFieldModel(type: .Parent)
        let sub1_0 = DataFieldModel(type: .EFN)
        sub1_0.value = qr.engFamilyName ?? "*****"
        sub1_0.random = hs_random()
        let sub1_1 = DataFieldModel(type: .EGN)
        sub1_1.value = qr.engGivenName ?? (qr.engGivenNameFirstLetter ?? "*****")
        sub1_1.random = hs_random()
//        let sub1_2 = DataFieldModel(type: .EGNF)
//        sub1_2.value = qr.EGNF!
//        sub1_2.random = hs_random()
        
        let sub1_3 = DataFieldModel(type: .PID)
        sub1_3.value = qr.idPhoto ?? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FFile%3ASample_User_Icon.png&psig=AOvVaw3EZzkjLT0JRAYeMM6YQo3d&ust=1625035980127000&source=images&cd=vfe&ved=0CAoQjRxqFwoTCLj88fSgvPECFQAAAAAdAAAAABAD"
        sub1_3.random = hs_random()
        
        let sub1_4 = DataFieldModel(type: .PID_hash)
        sub1_4.value = qr.idPhotoHash! ?? ""
        sub1_4.random = hs_random()
        
        
        sub1.children.append(sub1_0)
        sub1.children.append(sub1_1)
        sub1.children.append(sub1_3)
        sub1.children.append(sub1_4)
//        sub1.children.append(sub1_2)
        
        let sub2 = DataFieldModel(type: .Parent)
        let sub2_0 = DataFieldModel(type: .DT)
        sub2_0.value = qr.docType ?? "*****"
        sub2_0.random = hs_random()
        let sub2_1 = DataFieldModel(type: .DN)
        sub2_1.value = qr.docNumber ?? ((qr.docNumberFirstHalf ??  "****" + (qr.docNumberSecondHalf ?? "*****")) )
        sub2_1.random = hs_random()
//        let sub2_2 = DataFieldModel(type: .DNF)
//        sub2_2.value = qr.DNF!
//        sub2_2.random = hs_random()
//        let sub2_3 = DataFieldModel(type: .DNL)
//        sub2_3.value = qr.DNL!
//        sub2_3.random = hs_random()
        let sub2_4 = DataFieldModel(type: .PNF)
        sub2_4.value = qr.passportNumberFirstHalf ?? (qr.passportNumberFirstHalf ?? "*****")
        sub2_4.random = hs_random()
        let sub2_5 = DataFieldModel(type: .PNL)
        sub2_5.value = qr.passportNumberSecondHalf ?? (qr.passportNumberSecondHalf ?? "*****")
        sub2_5.random = hs_random()
        let sub2_6 = DataFieldModel(type: .MTPNF)
        sub2_6.value = qr.mainlandTravelPermitNoFirstHalf ?? (qr.mainlandTravelPermitNoFirstHalf ?? "*****")
        sub2_6.random = hs_random()
        let sub2_7 = DataFieldModel(type: .MTPNL)
        sub2_7.value = qr.mainlandTravelPermitNoSecondHalf ?? (qr.mainlandTravelPermitNoSecondHalf ?? "*****")
        sub2_7.random = hs_random()
        
        sub2.children.append(sub2_0)
        sub2.children.append(sub2_1)
        sub2.children.append(sub2_4)
        sub2.children.append(sub2_5)
        sub2.children.append(sub2_6)
        sub2.children.append(sub2_7)
//        sub2.children.append(sub2_2)
//        sub2.children.append(sub2_3)
        
        parent.children.append(sub0)
        parent.children.append(sub1)
        parent.children.append(sub2)
        
        return parent
    }
    private class func qrRecordsNode(qr:QRJson) -> DataFieldModel {
        let parent = DataFieldModel(type: .Parent)
        
        let sub0 = DataFieldModel(type: .Parent)
        let sub0_0 = DataFieldModel(type: .FVN)
        sub0_0.value = qr.vaxName_1 ?? "*****"
        sub0_0.random = hs_random()
        let sub0_1 = DataFieldModel(type: .FVLN)
        sub0_1.value = qr.lotNumber_1 ?? "*****"
        sub0_1.random = hs_random()
        let sub0_2 = DataFieldModel(type: .FVD)
        sub0_2.value = qr.vaxDate_1 ?? "*****"
        sub0_2.date = VaccDateFormatter.date(from: sub0_2.value)
        sub0_2.random = hs_random()
        let sub0_3 = DataFieldModel(type: .FVP)
        sub0_3.value = qr.vaxLocation_1 ?? "*****"
        sub0_3.random = hs_random()
        
        sub0.children.append(sub0_0)
        sub0.children.append(sub0_1)
        sub0.children.append(sub0_2)
        sub0.children.append(sub0_3)
        
        let sub1 = DataFieldModel(type: .Parent)
        let sub1_0 = DataFieldModel(type: .SVN)
        sub1_0.value = qr.vaxName_1 ?? "*****"
        sub1_0.random = hs_random()
        let sub1_1 = DataFieldModel(type: .SVLN)
        sub1_1.value = qr.lotNumber_2 ?? "*****"
        sub1_1.random = hs_random()
        let sub1_2 = DataFieldModel(type: .SVD)
        sub1_2.value = qr.vaxDate_2 ?? "*****"
        sub1_2.date = VaccDateFormatter.date(from: sub1_2.value)
        sub1_2.random = hs_random()
        let sub1_3 = DataFieldModel(type: .SVP)
        sub1_3.value = qr.vaxLocation_2 ?? "*****"
        sub1_3.random = hs_random()
        
        sub1.children.append(sub1_0)
        sub1.children.append(sub1_1)
        sub1.children.append(sub1_2)
        sub1.children.append(sub1_3)
        
        parent.children.append(sub0)
        parent.children.append(sub1)
        
        return parent
    }
//    private class func qrTestResultsNode(qr:QRJson) -> DataFieldModel {
//        // need to change to loop later
//        let parent = DataFieldModel(type: .Parent)
//        
//        let sub0 = DataFieldModel(type: .Parent)
//        let sub0_0 = DataFieldModel(type: .NSCD)
//        sub0_0.value = qr.NSCD!
//        sub0_0.date = VaccDateFormatter.date(from: sub0_0.value)
//        sub0_0.random = hs_random()
//        let sub0_2 = DataFieldModel(type: .NTR)
//        sub0_2.value = qr.NTR!
//        sub0_2.random = hs_random()
//        
//        sub0.children.append(sub0_0)
//        sub0.children.append(sub0_2)
//        
//        let sub1 = DataFieldModel(type: .Parent)
//        let sub1_0 = DataFieldModel(type: .ISCD)
//        sub1_0.value = qr.ISCD!
//        sub1_0.date = VaccDateFormatter.date(from: sub1_0.value)
//        sub1_0.random = hs_random()
//        let sub1_2 = DataFieldModel(type: .ITR)
//        sub1_2.value = qr.ITR!
//        sub1_2.random = hs_random()
//        
//        sub1.children.append(sub1_0)
//        sub1.children.append(sub1_2)
//        
//        let sub2 = DataFieldModel(type: .Parent)
//        let sub2_0 = DataFieldModel(type: .NSCD)
//        sub2_0.value = qr.NSCD!
//        sub2_0.date = VaccDateFormatter.date(from: sub2_0.value)
//        sub2_0.random = hs_random()
//        let sub2_2 = DataFieldModel(type: .NTR)
//        sub2_2.value = qr.NTR!
//        sub2_2.random = hs_random()
//        
//        sub2.children.append(sub2_0)
//        sub2.children.append(sub2_2)
//        
//        parent.children.append(sub0)
//        parent.children.append(sub1)
//        parent.children.append(sub2)
//        
//        return parent
//    }
}
