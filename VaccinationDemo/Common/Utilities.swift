//
//  Utilities.swift
//  VaccinationDemo
//
//  Created by guofeng on 2021/3/31.
//  Copyright © 2021 guofeng. All rights reserved.
//

import Foundation

func += <K,V> ( left: inout Dictionary<K,V>, right: Dictionary<K,V>?) {
    guard let right = right else { return }
    right.forEach { key, value in
        left.updateValue(value, forKey: key)
    }
}

///是否为nil或空字符串
public func IsNilOrEmptyString(_ string: String?) -> Bool {
    if string == nil || string!.isEmpty {
        return true
    }
    return false
}

///Int转String
public func IntToString(_ number: Int?) -> String {
    return String.init(describing: number ?? 0)
}

///随机数[from, to]
public func RandomNumber(from: Int, to: Int) -> Int {
    let random = (from + (Int(arc4random()) % (to - from + 1)))
    return random
}

public func UUID() -> String {
    let uuid = CFUUIDCreate(nil)
    let uuidStr = CFUUIDCreateString(nil, uuid)
    return (uuidStr as String?) ?? ""
}
public func TidyUUID() -> String {
    return UUID().replacingOccurrences(of: "-", with: "")
}
