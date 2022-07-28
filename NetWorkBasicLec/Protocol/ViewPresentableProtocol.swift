//
//  ViewPresentableProtocol.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/07/28.
//

import UIKit

/*
 naming: ~~~ Protocol
         ~~~ Delegate
 
 */

// 실질적인 구현부를 작성 X
// 실질적인 구현은 프로토콜을 채택, 준수한 타입이 구현한다.
// 클래스, 구조체, 익스텐션, 열거형...
// 클래스는 단일 상속만 가능, 프로토콜은 채택 개수에 제한이 없습니다!!
// 선택적 요청(Optional Requirement) -> @objc optional

// 프로토콜 프로퍼티: 연산 프로퍼티로 쓰던, 저장프로퍼티로 쓰던 상관하지 않는다. (property observer도 상관 X)
// 무조건 var로 선언해야한다.

// 만약 get을 명시했다면, get 기능만 최소한 구현되어 있으면 된다. 그래도 필요하다면 set을 구현해도 상관없다.
@objc protocol ViewPresentableProtocol {
    
    // get property는 구현부에서 let으로 변경할 수 있다.
    static var identifier: String { get }
    var backgroundColor: UIColor { get }
    // get set을 모두 구현해야하는 property는 var만 사용가능하다.
    var naviTitle: String { get set }
    
    func configureView() // 필수 구현
    @objc optional func configureLabel() // 선택적 구현
    @objc optional func configureTextField() // 선택적 구현
}

/*
    ex) 테이블뷰
 
 
 */

protocol OwenTabelViewDelegate {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell
}
