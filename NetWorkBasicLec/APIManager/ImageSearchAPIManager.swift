//
//  ImageSearchAPIManager.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

class ImageSearchAPIManager {
    
    static let shared = ImageSearchAPIManager()
    
    private init () { }
    
    typealias completionHandler = (Int, [String]) -> Void
    
    // Escaping Closure
    func fetchImageData(imageTitle: String, startPage: Int, displayCellCount: Int, completionHandler: @escaping completionHandler) {
        
        let url = Endpoint.imageSearchURL
        let utf8imageTitle = imageTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        print(utf8imageTitle)
        
        let header: HTTPHeaders = ["X-Naver-Client-Id" : AuthKey.NAVER_ID, "X-Naver-Client-Secret": AuthKey.NAVER_SECRET]
        let params: Parameters = ["query": "\(utf8imageTitle)", "display": displayCellCount, "start": startPage]
        
        // AF: 200 ~ 299 status code: Success
        AF.request(url, method: .get, parameters: params, headers: header).validate(statusCode: 200...500).responseJSON(queue: .global(qos: .default)) { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let totalCount = json["total"].intValue
                
                // json["items"].forEach { _, json in
                // self.stringURLArray.append(json["thumbnail"].string)
                // }
                
                let newResult = json["items"].arrayValue.map {
                    $0["thumbnail"].stringValue
                }
                
                completionHandler(totalCount, newResult)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
