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

        requestBeer()

        beerCollectionView.delegate = self
        beerCollectionView.dataSource = self
        beerCollectionView.collectionViewLayout = setCellSize()
        
        setUI()
    }
    
    func setUI() {
        self.view.backgroundColor = .orange
        beerCollectionView.backgroundColor = .clear
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
        
        return beerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerCollectionViewCell.identifier, for: indexPath) as? BeerCollectionViewCell else { return UICollectionViewCell()}
        
        cell.beerTitleView.text = self.beerArray[indexPath.row].beerName
        
        let imageString = self.beerArray[indexPath.row].beerImageURLString ?? "https://image.shutterstock.com/image-vector/love-beer-image-font-type-600w-331233908.jpg"
        
        let url = URL(string: imageString)!
        
        cell.beerImageView.kf.setImage(with: url)
        
        cell.cellCongigure()
        
        return cell
    }//: cellForItemAt
    
    func requestBeer() {
        
        let url = "https://api.punkapi.com/v2/beers"

        DispatchQueue.global(qos: .userInteractive).async {

            AF.request(url, method: .get).validate().responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    
                    for beer in json {
                        self.beerArray.append(BeerInfo(beerName: beer.1["name"].stringValue, beerImageURLString: beer.1["image_url"].string, description: beer.1["description"].string))
                    }
                    
                    self.beerCollectionView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let descriptionVC = self.storyboard?.instantiateViewController(withIdentifier: BeerDescriptionViewController.identifier) as? BeerDescriptionViewController else { return }
        
        descriptionVC.beerDescription = beerArray[indexPath.row].description
        
        present(descriptionVC, animated: true)
    }
    
}
