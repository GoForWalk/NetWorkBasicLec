//
//  UserDefaultsHelper.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/01.
//

import Foundation

class UserDefaultsHelper {
    
    // singleton pattern: 자기자신의 인트턴스를 타입 프로퍼티 형태로 가지고 있다.
    static let standard = UserDefaultsHelper()
    // standard, shared, default
    
    let userDefaults = UserDefaults.standard
    
    private init() {}
    
    enum Key: String {
        case nickname, age
    }
    
    var nickname: String? {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
}
