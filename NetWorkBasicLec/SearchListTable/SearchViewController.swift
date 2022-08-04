//
//  SearchViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/07/27.
//

import UIKit

import Alamofire
import SwiftyJSON
import JGProgressHUD
/*
 Swift Protocol
 - Delegate
 - DataSource
 
 1. 왼팔, 오른팔
 2. 테이블 뷰 아웃렛 연결
 3. 아웃렛에 Delegate, DataSource 연결
 */

/*
 각 json value -> list -> 테이블뷰 갱신
 서버의 응답이 몇개인지 모를 경우??
 
 */

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    let hud = JGProgressHUD()
    
    // boxOffice 배열
    var list: [BoxOfficeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 핵 중요한 코드!!
        // tableView에 delegate, dataSource 연결 > 뷰컨에 요청
        // delegate Pattern
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        searchBar.delegate = self
        
        
        // 테이블 뷰가 사용할 테이블뷰 셀(XIB) 등록
        // XIB: xml interface builder <= Nib
        searchTableView.register(UINib(nibName: ListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
        
        requestBoxOffice(dateText: getYesterday())
    }
    
    func requestBoxOffice(dateText: String){
        
        hud.textLabel.text = "Loading"
        hud.show(in: self.view, animated: true)
        
        self.list.removeAll()
                    
        let url = "\(Endpoint.boxOfficeURL)key=\(AuthKey.BOXOFFICE)&targetDt=\(dateText)"
        
        DispatchQueue.global(qos: .userInteractive).async {
            // AF: 200 ~ 299 status code: Success
            AF.request(url, method: .get).validate().responseData { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                        
                        let movieNm = movie["movieNm"].stringValue
                        let movieDate = movie["openDt"].stringValue
                        let totalAudi = movie["audiAcc"].stringValue
                        
                        let movie = BoxOfficeModel(movieTitle: movieNm, releaseDate: movieDate, totalCount: totalAudi)
                        
                        self.list.append(movie)
                    }
                    
                    self.searchTableView.reloadData()
                    self.hud.dismiss(animated: true)
                    
                    print(self.list)
                case .failure(let error):
                    print(error)
                    
                    // 시뮬레이터 실패 테스트 >
                    
                }
            }
        }
        
    }

    
    // 필수 구현
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    // 필수 구현
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
      
        cell.backgroundColor = .clear
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle): \(list[indexPath.row].releaseDate)"
        
        return cell
    }
        
    func getYesterday() -> String {

        let date = Date.now
        let formatter = DateFormatter()

        formatter.locale = Locale.init(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyyMMdd"

        let yesterdaty = Calendar.current.date(byAdding: DateComponents(day: -1), to: date)!

        print(formatter.string(from: yesterdaty))
        
        let result = formatter.string(from: yesterdaty)
        
        searchBar.text = result
        
        return result
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    // 날짜에 대한 유효성 검사
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(dateText: searchBar.text!)
    }
    
}
