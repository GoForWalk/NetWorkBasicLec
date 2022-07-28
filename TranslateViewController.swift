//
//  TranslateViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/07/28.
//

import UIKit

// control 에 기반한 객체를 상속받지 않아서
// UIResponder chain

class TranslateViewController: UIViewController {
    
    let placeholderText = "문장을 입력하세요."

    @IBOutlet weak var userInputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userInputTextView.delegate = self
        
        userInputTextView.text = placeholderText
        userInputTextView.textColor = .lightGray
    }
    
    @IBAction func EditEndButtonTapped(_ sender: UIButton) {
        userInputTextView.resignFirstResponder()
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
