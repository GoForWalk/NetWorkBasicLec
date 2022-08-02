//
//  BeerCollectionViewCell.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/02.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerTitleView: UILabel!

    func cellCongigure() {
        
        beerImageView.backgroundColor = .clear
        beerTitleView.backgroundColor = .clear
        
        beerTitleView.font = .systemFont(ofSize: 24)
    }
}
