//
//  SearchViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/07/27.
//

import UIKit

/*
 Swift Protocol
 - Delegate
 - DataSource
 
 1. 왼팔, 오른팔
 2. 테이블 뷰 아웃렛 연결
 3. 아웃렛에 Delegate, DataSource 연결
 */

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 핵 중요한 코드!!
        // tableView에 delegate, dataSource 연결 > 뷰컨에 요청
        // delegate Pattern
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        // 테이블 뷰가 사용할 테이블뷰 셀(XIB) 등록
        // XIB: xml interface builder <= Nib
        searchTableView.register(UINib(nibName: ListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    // 필수 구현
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    // 필수 구현
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
      
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "Hello"
        
        return cell
    }
    
    
}
