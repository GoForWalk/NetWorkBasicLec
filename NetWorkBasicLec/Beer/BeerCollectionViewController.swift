//
//  BeerCollectionViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/02.
//

import UIKit

import SwiftyJSON
import Kingfisher
import Alamofire

struct BeerInfo {
    var beerName: String
    var beerImageURLString: String?
    var description: String?
}

class BeerCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var beerCollectionView: UICollectionView!
    
    var beerArray: [BeerInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beerCollectionView.delegate = self
        beerCollectionView.dataSource = self
        beerCollectionView.collectionViewLayout = setCellSize()
        
    }
    
    func setCellSize() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 12
        let numOfCell: CGFloat = 2
        let numOfSpace: CGFloat = numOfCell + 1
        
        let width = (UIScreen.main.bounds.width - (spacing * numOfSpace)) / numOfCell
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        return layout
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerCollectionViewCell.identifier, for: indexPath) as? BeerCollectionViewCell else { return UICollectionViewCell()}
        
        let url = "https://api.punkapi.com/v2/beers"
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            AF.request(url, method: .get).validate().responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    
                    for beer in json {
                        self.beerArray.append(BeerInfo(beerName: beer.1["name"].stringValue, beerImageURLString: beer.1["image_url"].string, description: beer.1["description"].string))
                        
                        DispatchQueue.main.async {
                         
                            cell.beerTitleView.text = self.beerArray[indexPath.row].beerName
                            
                            let imageString = self.beerArray[indexPath.row].beerImageURLString ?? "https://image.shutterstock.com/image-vector/love-beer-image-font-type-600w-331233908.jpg"
                            
                            guard let url = URL(string: imageString) else { return }
                            
                            cell.beerImageView.kf.setImage(with: url)
                            
                            
                        }
                    }
                    
                    print(self.beerArray)
                    
                case .failure(let error):
                    print(error)
                }
            }

        }
        
        cell.cellCongigure()
        
        return cell
    }//: cellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let descriptionVC = self.storyboard?.instantiateViewController(withIdentifier: BeerDescriptionViewController.identifier) as? BeerDescriptionViewController else { return }
        
        descriptionVC.beerDescription = beerArray[indexPath.row].description
        
        present(descriptionVC, animated: true)
    }
    
}
