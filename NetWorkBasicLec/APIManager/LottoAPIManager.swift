//
//  LottoAPIManager.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/07.
//

import Foundation

import Alamofire
import SwiftyJSON


class LottoAPIManager {
    
    let lottoModel = LottoModel.shared
    
    static let shared = LottoAPIManager()
    
    private init () {}
    
    func fetchLottoAPI(number: Int, completionHandler: @escaping ([Int], String) -> Void) {
        print(#function, "FetchLottoAPI Started: \(number)회차")
        let url = "\(Endpoint.lottoURL)method=getLottoNumber&drwNo=\(number)"

        // AF: 200 ~ 299 status code: Success
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseData(queue: .global(qos: .default)) { [weak self] response in
                
            guard let self = self else { return }
            
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    
                    let bonus = json["bnusNo"].intValue
                    let date = json["drwNoDate"].stringValue
                    print(bonus, date)
                    
                    let winNumber: [Int] = [json["drwtNo1"].intValue, json["drwtNo2"].intValue, json["drwtNo3"].intValue, json["drwtNo4"].intValue, json["drwtNo5"].intValue, json["drwtNo6"].intValue, json["bnusNo"].intValue]
                    
                    self.lottoModel.appendWinNumber(key: number, winNumber: winNumber)
                    self.lottoModel.appendDate(key: number, date: date)
                    
                    completionHandler(winNumber, date)
                    
                case .failure(let error):
                    print(error)
                }
            }
        
    }
    
}
