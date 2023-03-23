//
//  SearchResultView.swift
//  AppStore_KAKAOBANK
//
//  Created by 이찬호 on 2023/03/19.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

enum SearchType {
    case list
    case result
}

enum SearchMethod {
    case direct
    case didSelect
}

protocol PushNavigationDelegate {
    func goDetailView(_ data: SearchResult?)
    func selectList(_ text: String)
}

class SearchResultView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchViewModel = SearchViewModel.shared
    var type: SearchType = .list
    var delegate: PushNavigationDelegate?
    var searchData: SearchResultModel?
    var disposeBag = DisposeBag()
    var recentSearchData = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setData()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let listCell = UINib(nibName: "SearchListCell", bundle: nil)
        tableView.register(listCell, forCellReuseIdentifier: "SearchListCell")
        
        let resultCell = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(resultCell, forCellReuseIdentifier: "SearchResultCell")
    }
}

extension SearchResultView {
    func setData() {
        searchViewModel.output.searchResult
            .subscribe(onNext: {[weak self] data in
                self?.searchData = data
                self?.tableView.reloadData()
            },
            onError: {[weak self] error in
                print("error: ",error)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchResultView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == .list {
            return 40.0
        } else {
            return 375.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData?.resultCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == .list {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchListCell", for:  indexPath) as! SearchListCell
            
            let trackName = searchData?.results?[indexPath.row].trackName ?? ""
            cell.listLabel.text = trackName
            
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for:  indexPath) as! SearchResultCell
            
            cell.selectionStyle = .none
            
            let trackName = searchData?.results?[indexPath.row].trackName ?? ""
            if let genres = searchData?.results?[indexPath.row].genres {
                cell.title.text = genres[0]
            }
            
            let appIconUrl = searchData?.results?[indexPath.row].artworkUrl100 ?? ""
            let screenshotUrls = searchData?.results?[indexPath.row].screenshotUrls ?? [""]
            let averageUserRating = searchData?.results?[indexPath.row].averageUserRating ?? 0
            let userRatingCount = searchData?.results?[indexPath.row].userRatingCount ?? 0
            
            cell.appName.text = trackName
            cell.appIconImage.kf.setImage(with: URL(string: appIconUrl))
            cell.appIconImage.layer.cornerRadius = 20
            cell.appIconImage.layer.masksToBounds = true
            
            if screenshotUrls.count >= 3 {
                cell.screenShot_1.kf.setImage(with: URL(string: screenshotUrls[0]))
                cell.screenShot_2.kf.setImage(with: URL(string: screenshotUrls[1]))
                cell.screenShot_3.kf.setImage(with: URL(string: screenshotUrls[2]))
            } else if screenshotUrls.count == 2 {
                cell.screenShot_1.kf.setImage(with: URL(string: screenshotUrls[0]))
                cell.screenShot_2.kf.setImage(with: URL(string: screenshotUrls[1]))
            } else if screenshotUrls.count == 1 {
                cell.screenShot_1.kf.setImage(with: URL(string: screenshotUrls[0]))
            }
            
            cell.cosmosView.rating = averageUserRating
            cell.cosmosView.text = "\(userRatingCount)"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .list {
            let trackName = searchData?.results?[indexPath.row].trackName ?? ""
            delegate?.selectList(trackName)
        } else {
            let searchDetailData = searchData?.results?[indexPath.row]
            delegate?.goDetailView(searchDetailData)
        }
    }
}
