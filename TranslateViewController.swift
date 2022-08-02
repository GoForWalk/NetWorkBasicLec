//
//  TranslateViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON
// control 에 기반한 객체를 상속받지 않아서
// UIResponder chain

class TranslateViewController: UIViewController {
    
    static let fontName = "MabinogiClassicOTFR"
    
    let placeholderText = "문장을 입력하세요."
    let resultPlaceholderText = "번역 결과가 나옵니다."
    
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        userInputTextView.delegate = self
        
        userInputTextView.text = placeholderText
        userInputTextView.textColor = .lightGray
        
        userInputTextView.font = UIFont(name: TranslateViewController.fontName, size: 17)
        
        resultTextView.text = resultPlaceholderText
        resultTextView.textColor = .lightGray
        resultTextView.font = UIFont(name: TranslateViewController.fontName, size: 17)
    }
    
    @IBAction func EditEndButtonTapped(_ sender: UIButton) {
        userInputTextView.resignFirstResponder()

        requestTranslate(text: userInputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    @IBAction func webViewButtonTapped(_ sender: UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: WebViewController.identifier) as? WebViewController else { return }
        
        present(vc, animated: true)
    }
    
    // header 추가
    func requestTranslate(text: String){
        let url = (Endpoint.translateURL)
        
        let header: HTTPHeaders = ["X-Naver-Client-Id" : AuthKey.NAVER_ID, "X-Naver-Client-Secret": AuthKey.NAVER_SECRET]
        let params: Parameters = ["source": "ko", "target": "en", "text": text]
        
        DispatchQueue.global(qos: .userInteractive).async {
            // AF: 200 ~ 299 status code: Success
            AF.request(url, method: .post, parameters: params, headers: header).validate(statusCode: 200...500).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    let statusCode = response.response?.statusCode ?? 500
                    
                    DispatchQueue.main.async {

                        // 에러값을 validate안에 추가하여, 파파고에서 제공하는 오류 메세지 띄워보기
                        // 상태 코드에 따은 처리 필요
                        // Response
                        if statusCode == 200 {
                            self.resultTextView.text = json["message"]["result"]["translatedText"].stringValue
                        } else {
                            self.resultTextView.text = json["errorMessage"].stringValue
                        }
                        
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}

// 메서드를 컨트롤
extension TranslateViewController: UITextViewDelegate {
    
    // 텍스트뷰의 텍스트가 변할때 마다 호출
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
    }
    
    // 편집이 시작될 때, 커서가 시작될 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Begin")
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
        
    }
    
    // 편집이 끝났을 때, 커서가 없어지는 순간
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End")
        
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}
