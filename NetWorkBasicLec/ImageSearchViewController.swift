//
//  ImageSearchViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/08/03.
//

import UIKit

import Kingfisher

class ImageSearchViewController: UIViewController {

    var stringURLArray: [String?] = []
    
    var startPage = 1
    let displayCellCount = 100
    var totalCellCount = 0
    
    @IBOutlet weak var imageSearchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.collectionViewLayout = setCellSize()
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        searchCollectionView.prefetchDataSource = self
        imageSearchBar.delegate = self
    }

    // fetch..., request..., callRequest..., get... -> response에 따라 네이밍을 설정해주기도 함.
    func fetchImage(imageTitle: String) {
        ImageSearchAPIManager.shared.fetchImageData(imageTitle: imageTitle, startPage: startPage, displayCellCount: displayCellCount) { totalCellCount, stringURLArray in
            self.stringURLArray.append(contentsOf: stringURLArray)
            self.totalCellCount = totalCellCount
            
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
        }
    }//: fetchImage
    
}

// 페이지네이션 방법3.
// 용량이 큰 이미지를 다운받아서 셀에 보여주려고 하는 경우에 효과적
// 셀이 화면에 보이기 전에 미리 필요한 리소스를 다운받을 수 있고, 필요하지 않다면 데이터를 취소할 수도 있음.
// iOS10 이상부터 사용가능, 스크롤 성능 향상가능.
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    
    // cell이 화면에 보이기 직전에 리로스를 미리 다운 받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("==============\(indexPaths)")
        
        for indexPath in indexPaths {
            if stringURLArray.count - 1 == indexPath.item, stringURLArray.count < totalCellCount {
                startPage += displayCellCount
                // TODO: 처리 필요
                fetchImage(imageTitle: imageSearchBar.text!)
            }
        }
    }
    
    // 작업을 취소할 때
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("==========취소\(indexPaths)")
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    // 검색 버튼 클릭 시 실행
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 검색버튼 클릭 시 실행, 검색 단어가 바뀔 수 있음
        if let text = searchBar.text {
            stringURLArray.removeAll()
            startPage = 1
            fetchImage(imageTitle: text)
            // TODO: 아래 코드 알아보기
//            searchCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    // 취소버튼 눌렀을 경우
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    // 서치바에 커서가 깜빡이기 시작할 때 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 페이지네이션 방법1.
    // 컬렉션 뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    // 마지막에 셀에 사용자가 위치해 있는지 명확하게 확인하기가 어려움
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //
    //    }

    // 페이지네이션 방법2.
    // UIScrollViewDelegateProtocol 사용
    // 테이블뷰/콜렉션뷰는 스크롤뷰를 상속받고 있어서, 스크롤뷰 프로토콜을 사용할 수 있다.
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        print(scrollView.contentOffset.y)
    //    }
    
    func setCellSize() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 12
        let numOfCell: CGFloat = 3
        let numOfSpace: CGFloat = numOfCell + 1
        
        let width = (UIScreen.main.bounds.width - (spacing * numOfSpace)) / numOfCell
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width, height: width * 1)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stringURLArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.identifier, for: indexPath) as? ImageSearchCollectionViewCell else { return UICollectionViewCell() }
        
        let url = URL(string: stringURLArray[indexPath.item] ?? "https://dublab-api-1.s3.amazonaws.com/uploads/2012/10/non_720px-700x700.jpg")
        
        cell.searchImageView.kf.setImage(with: url)
        
        return cell
    }

}
