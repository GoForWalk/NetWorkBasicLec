//
//  ViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/07/27.
//

import UIKit

class ViewController: UIViewController, ViewPresentableProtocol {
    
    static let identifier: String = "ViewController"
    
    var backgroundColor: UIColor {
        get {
            return UIColor.systemCyan
        }
    }
    
    var naviTitle: String = "coconut"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    func configureView() {
        view.backgroundColor = backgroundColor
    }

}

