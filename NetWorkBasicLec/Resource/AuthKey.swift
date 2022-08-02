//
//  AuthKey.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/02.
//

import Foundation

enum AuthKey {
    static let BOXOFFICE = "fb093e2b25805a0cc45b8c00f65ef800"
    
    static let NAVER_SECRET = "5pI9w41d8G"
    static let NAVER_ID = "GiGyUzeSYrqNp03zhVMW"
}

struct Endpoint {
    static let boxOfficeURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static let lottoURL = "https://www.dhlottery.co.kr/common.do?"
    static let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
}
