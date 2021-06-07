//
//  String+Extension.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/3/31.
//  Copyright © 2021 guofeng. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    var sha256: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA256(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return String(format: hash as String)
    }
    
    ///url编码
    func urlEncode() -> String {
        if let encodeString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            return encodeString
        }
        return self
    }
    ///url解码
    func urlDecode() -> String {
        if let decodeString = self.removingPercentEncoding {
            return decodeString
        }
        return self
    }
}
