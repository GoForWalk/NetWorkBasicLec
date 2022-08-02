//
//  BeerDescriptionViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/02.
//

import UIKit

class BeerDescriptionViewController: UIViewController {

    @IBOutlet weak var beerDescriptionLabel: UILabel!
   
    var beerDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let beerDescription = beerDescription else {
            return
        }

        beerDescriptionLabel.text = beerDescription
        
    }
    

}
