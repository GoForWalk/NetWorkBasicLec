//
//  LottoModel.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/07.
//

import Foundation

final class LottoModel {
    
    static let shared = LottoModel()
    
    private init() {}
    
    private var winNumbersDic: [String : [Int]] = [:]
    private var datesDic: [String: String] = [:]
    
    private let winNumberKey = "winNumbers"
    private let datesKey = "dates"
    
    func getWinNumber(key: Int) -> [Int]? {
        guard let winNumberDic = UserDefaults.standard.dictionary(forKey: winNumberKey) as? [String: [Int]] else { return nil }
        winNumbersDic = winNumberDic
        getDatas(key: key)
        return winNumberDic["\(key)"] as [Int]?
    }
    
    func appendWinNumber(key: Int, winNumber: [Int]) {
        winNumbersDic["\(key)"] = winNumber
        UserDefaults.standard.set(winNumbersDic, forKey: winNumberKey)
    }
    
   @discardableResult func getDatas(key: Int) -> String? {
        guard let date = UserDefaults.standard.dictionary(forKey: datesKey) as? [String: String] else { return nil }
        datesDic = date
        return date["\(key)"]
    }
    
    func appendDate(key: Int, date: String) {
        datesDic["\(key)"] = date
        UserDefaults.standard.set(datesDic, forKey: datesKey)
    }

}
