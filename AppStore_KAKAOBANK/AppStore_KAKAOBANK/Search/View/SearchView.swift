//
//  SearchView.swift
//  AppStore_KAKAOBANK
//
//  Created by 이찬호 on 2023/03/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchView: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, PushNavigationDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchViewModel = SearchViewModel.shared
    var searchData: SearchResultModel?
    var disposeBag = DisposeBag()
    
    var searchController = UISearchController(searchResultsController: nil)
    let searchResultView = SearchResultView(nibName: "SearchResultView", bundle: nil)
    
    var recentSearchData = [""]
    var searchMethod: SearchMethod = .direct
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchView()
        setData()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setRecentData()
    }
    
    func setSearchView() {
        searchController = UISearchController(searchResultsController: searchResultView)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "검색"
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNib = UINib(nibName: "RecentSearchCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "RecentSearchCell")
    }
    
    func selectList(_ text: String) {
        updateRecentData(text)
        
        searchMethod = .didSelect
        
        searchController.searchBar.text = text
        searchController.searchBar.becomeFirstResponder()
    }
    
    func goDetailView(_ data: SearchResult?) {
        let detailView = DetailView(nibName: "DetailView", bundle: nil)
        detailView.searchData = data
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

extension SearchView {
    func updateSearchResults(for searchController: UISearchController) {
       
        guard let text = searchController.searchBar.text else { return }
        
        self.searchViewModel.searchText = text
        
        if searchMethod == .direct {
            searchResultView.type = .list
            searchResultView.recentSearchData = recentSearchData
        } else {
            searchResultView.type = .result
            searchController.searchBar.endEditing(true)
        }
        searchResultView.delegate = self
        searchResultView.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        updateRecentData(text)
        
        searchResultView.type = .result
        searchResultView.delegate = self
        searchResultView.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMethod = .direct
    }
}

extension SearchView: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        print("willPresentSearchController")
        
        searchResultView.type = .result
        searchResultView.delegate = self
        searchResultView.tableView.reloadData()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        print("didPresentSearchController")
        if searchMethod == .didSelect {
            searchMethod = .direct
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("willDismissSearchController")
        
        searchResultView.type = .list
        searchResultView.delegate = self
        searchResultView.tableView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("didDismissSearchController")
    }
}

extension SearchView {
    func setRecentData() {
        recentSearchData = UserDefaults.standard.stringArray(forKey: "recentSearch") ?? [String]()
        tableView.reloadData()
    }
    
    func updateRecentData(_ text: String) {
        var recentArr = UserDefaults.standard.stringArray(forKey: "recentSearch") ?? [String]()
        
        if recentArr.count > 0 {
            recentArr = recentArr.reversed()
        }

        if recentArr.count >= 4 {
            recentArr.removeFirst()
        }
        
        recentArr.append(text)
        
        if recentArr.count > 0 {
            recentArr = recentArr.reversed()
        }
        
        UserDefaults.standard.set(recentArr,
                                  forKey: "recentSearch")
        
        recentSearchData = recentArr
        tableView.reloadData()
    }
}


extension SearchView {
    func setData() {
        searchViewModel.output.searchResult
            .subscribe(onNext: {[weak self] data in
                self?.searchData = data
            },
            onError: {[weak self] error in
                print("error: ",error)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        titleLabel.text = "최근 검색어"
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textColor = .black
            
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalTo(20)
            make.height.equalTo(50)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for:  indexPath) as! RecentSearchCell
        cell.selectionStyle = .none
        
        cell.recentLabel.text = recentSearchData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = recentSearchData[indexPath.row]
        
        searchMethod = .didSelect
        
        searchController.searchBar.text = text
        searchController.searchBar.becomeFirstResponder()
    }
}
