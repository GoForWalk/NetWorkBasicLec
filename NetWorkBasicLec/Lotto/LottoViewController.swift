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

    let lottoAPIManager = LottoAPIManager.shared
    let lottoModel = LottoModel.shared
    
    @IBOutlet weak var numberTextField: UITextField!
//    @IBOutlet weak var lottoPickerView: UIPickerView!
    @IBOutlet var winNumberLabels: [UILabel]!
    

    var lottoPickerView = UIPickerView() // 클래스의 인스턴스 생성
        // 코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있다!!
    
//    let numberList: [Int] = Array(1...1025).reversed()
    var numberList: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNumberList()
        numberTextField.inputView = lottoPickerView
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        determineFetchAPI(number: numberList[0])
    }
    
    func setWinNumbers(winNumbers: [Int]?) {
        guard let winNumbers = winNumbers else { return }

        print(winNumbers)
        for number in (0...winNumbers.count - 1) {
            winNumberLabels[number].text = "\(winNumbers[number])"
        }
    }

    func requestLotto(number: Int){
        lottoAPIManager.fetchLottoAPI(number: number) { [weak self] winNumber, date in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.numberTextField.text = date
                self.setWinNumbers(winNumbers: winNumber)
            }

//            self.lottoModel.appendWinNumber(key: number, winNumber: winNumber)
//            self.lottoModel.appendDate(key: number, date: date)
        }
        
    }
    
    func determineFetchAPI(number: Int) {
        
        guard let winNumber = lottoModel.getWinNumber(key: number) else {
            requestLotto(number: number)
            return }
        print(#function, "\(number)회차 -> UserDefaults")
        setWinNumbers(winNumbers: winNumber)
        numberTextField.text = lottoModel.getDatas(key: number)!
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
        determineFetchAPI(number: numberList[row])
//        numberTextField.text = "\(numberList[row])회차"
        print(component, row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
    func getTotalNumber() -> Int {
        
        let calender = Calendar.current
        
        let formatter = DateFormatter()

        formatter.locale = Locale.init(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyy-MM-dd"

        let date = Date.now
        let stringDate = "2002-12-07"

        let dataData = formatter.date(from: stringDate)!

        let thisSunday = calender.dateComponents([.day], from: dataData, to: date )

        return (thisSunday.day! / 7) + 1
    }
    
    func setNumberList() {
        let tempIntArray: [Int] = Array(1...getTotalNumber())
        
        numberList = tempIntArray.reversed()
        UserDefaults.standard.set(numberList.first, forKey: "lastTotalNumber")
    }
    
}
