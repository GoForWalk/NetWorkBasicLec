//
//  RandomBeerViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/01.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class RandomBeerViewController: UIViewController {

    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        requestRandomBeer()

    }
    
    func setUI() {
        setNameLabel()
    }
    
    func setNameLabel() {
        beerNameLabel.font = .systemFont(ofSize: 20, weight: .heavy)
    }
    
    func setData(beerName: String, description: String?) {
        beerNameLabel.text = beerName
        
        guard let description = description else { return }
        beerDescription.text = description
    }
    
    
    func requestRandomBeer() {
        
        let urlString = "https://api.punkapi.com/v2/beers/random"
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            AF.request(urlString, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    let beerInfo = json[0]
                    
                    let name = beerInfo["name"].stringValue
                    let imageString = beerInfo["image_url"].string
                    let description = beerInfo["description"].string
                    
                    print(name, imageString, description)
                    self.getBeerImage(imageURL: imageString)
                    
                    DispatchQueue.main.async {
                        self.setData(beerName: name, description: description)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }//: requestRandomBeer
    
    func getBeerImage(imageURL: String?) {
        let urlString = imageURL ?? "https://image.shutterstock.com/image-vector/love-beer-image-font-type-600w-331233908.jpg"
        let url = URL(string: urlString)
        
        beerImageView.kf.setImage(with: url)
    }
    
    @IBAction func getBeerButtonTapped(_ sender: UIButton) {
        requestRandomBeer()
    }
    
}
