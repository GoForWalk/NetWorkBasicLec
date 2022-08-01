//
//  LottoViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    @IBOutlet var winNumberLabels: [UILabel]!
    

    var lottoPickerView = UIPickerView() // 클래스의 인스턴스 생성
        // 코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있다!!
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberTextField.inputView = lottoPickerView
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        requestLotto(number: numberList[0])
    }
    
    func setWinNumbers(winNumbers: [Int]?) {
        guard let winNumbers = winNumbers else { return }

        print(winNumbers)
        for number in (0...winNumbers.count - 1) {
            winNumberLabels[number].text = "\(winNumbers[number])"
        }
    }

    func requestLotto(number: Int){
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"

        DispatchQueue.global(qos: .userInteractive).async {
            // AF: 200 ~ 299 status code: Success
            AF.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    let bonus = json["bnusNo"].intValue
                    let date = json["drwNoDate"].stringValue
                    print(bonus, date)
                    
                    let winNumber: [Int] = [json["drwtNo1"].intValue, json["drwtNo2"].intValue, json["drwtNo3"].intValue, json["drwtNo4"].intValue, json["drwtNo5"].intValue, json["drwtNo6"].intValue, json["bnusNo"].intValue]
                    
                    DispatchQueue.main.async {
                        self.numberTextField.text = date
                        self.setWinNumbers(winNumbers: winNumber)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// PickerView
extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLotto(number: numberList[row])
//        numberTextField.text = "\(numberList[row])회차"
        print(component, row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
