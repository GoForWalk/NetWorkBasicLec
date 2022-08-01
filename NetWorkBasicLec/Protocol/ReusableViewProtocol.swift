//
//  ReusableViewProtocol.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/01.
//

import UIKit

protocol ResuebleViewProtocol {
    
    static var identifier: String { get }
    
}


extension UIViewController: ResuebleViewProtocol {// extension 저장 프로퍼티 불가능
    
    static var identifier: String { // 연산 프로퍼티 get만 사용한다면, get 생략 가능
        return String(describing: self)
    }
    
}

extension UITableViewCell: ResuebleViewProtocol {
    static var identifier: String { // 연산 프로퍼티 get만 사용한다면, get 생략 가능
        return String(describing: self)
    }
}
