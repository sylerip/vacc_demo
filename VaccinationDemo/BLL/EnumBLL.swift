//
//  EnumBLL.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/4/3.
//  Copyright © 2021 guofeng. All rights reserved.
//

import Foundation

enum DataFieldType: Int {
    ///父节点
    case Parent = 0
    
    ///中文姓
    case CFN = 101
    ///中文名
    case CGN
    ///英文姓
    case EFN
    ///英文名
    case EGN
    
    case EGNF
    
    case PID
    
    case PID_hash
    
    ///身份证明文件类别
    case DT
    ///身份证明文件号码
    case DN
    // ID first half
    case DNF
    // ID second half
    case DNL
    // passport first half
    case PNF
    //passport second half
    case PNL
    // Mainland Travel Permit No first half
    case MTPNF
    // Mainland Travel Permit No second half
    case MTPNL
    
    ///疫苗名称(第一针)
    case FVN
    ///疫苗批号
    case FVLN
    ///接种日期
    case FVD
    ///接种地点
    case FVP
    
    ///疫苗名称(第二针)
    case SVN
    ///疫苗批号
    case SVLN
    ///接种日期
    case SVD
    ///接种地点
    case SVP
    
    ///核酸检测采样日期
    case NSCD
    ///核酸检测结果
    case NTR
    
    ///IgG检测采样日期
    case ISCD
    ///IgG检测结果
    case ITR
    
    case HDR
    
    case DP
    
    
    ///字段标识
    func fieldName() -> String {
        var ret: String
        switch self {
        case .Parent:
            ret = "Parent"
            
        case .CFN:
            ret = "CFN"
        case .CGN:
            ret = "CGN"
        case .EFN:
            ret = "engFamilyName"
        case .EGN:
            ret = "engGivenName"
        case .EGNF:
            ret = "engGivenNameFirstLetter"
        case .PID:
            ret = "idPhoto"
        case .PID_hash:
            ret = "idPhotoHash"
        case .DT:
            ret = "docType"
        case .DN:
            ret = "docNumber"
        case .DNF:
            ret = "docNumberFirstHalf"
        case .DNL:
            ret = "docNumberSecondHalf"
        case .PNF:
            ret = "passportNumberFirstHalf"
        case .PNL:
            ret = "passportNumberSecondHalf"
        case .MTPNF:
            ret = "mainlandTravelPermitNoFirstHalf"
        case .MTPNL:
            ret = "mainlandTravelPermitNoSecondHalf"
        case .FVN:
            ret = "vaxName_1"
        case .FVLN:
            ret = "lotNumber_1"
        case .FVD:
            ret = "vaxDate_1"
        case .FVP:
            ret = "vaxLocation_1"
            
        case .SVN:
            ret = "vaxName_2"
        case .SVLN:
            ret = "lotNumber_2"
        case .SVD:
            ret = "vaxDate_2"
        case .SVP:
            ret = "vaxLocation_2"
            
        case .NSCD:
            ret = "NSCD"
        case .NTR:
            ret = "NTR"
            
        case .ISCD:
            ret = "ISCD"
        case .ITR:
            ret = "ITR"
        case .HDR:
            ret = "hiddenDateRange"
        case .DP:
            ret = "proof"
        }
        return ret
    }
}

enum DateStyle: Int {
    case exact
    case week
    case month
    case hide
}

enum TestResult: String {
    ///阴性
    case Negative = "1"
    ///阳性
    case Positive = "0"
    
    func name() -> String {
        switch self {
        case .Negative:
            return "Negative"
        case .Positive:
            return "Positive"
        }
    }
}
