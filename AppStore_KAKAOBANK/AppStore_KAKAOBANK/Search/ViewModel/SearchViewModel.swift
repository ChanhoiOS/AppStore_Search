//
//  SearchViewModel.swift
//  AppStore_KAKAOBANK
//
//  Created by 이찬호 on 2023/03/19.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchViewModelType {
    associatedtype Input
    associatedtype Output
}

class SearchViewModel: SearchViewModelType {
    
    var input: Input
    var output: Output
    var disposeBag = DisposeBag()
    
    static var shared = SearchViewModel()
    
    var searchText: String = "" {
       didSet {
           self.getAppStoreRequest(searchText)
       }
    }
    
    struct Input {
        var searchText = PublishSubject<String>()
    }
    
    struct Output {
        var searchResult = PublishSubject<SearchResultModel>()
    }
    
    init() {
        input = Input(searchText: PublishSubject<String>())
        output = Output(searchResult: PublishSubject<SearchResultModel>())
    }
    
    func getAppStoreRequest(_ text: String) {

        var param = [String: Any]()
        param["term"] = text
        param["country"] = "KR"
        param["media"] = "software"
        param["limit"] = 13

        NetworkManager.getSearchData(url: Apis.search, param: param)
            .subscribe(onNext: { [weak self] response in
                switch response {
                case .success(let data):
                    self?.output.searchResult.onNext(data)
                case .failure(let error):
                    print("error: ",error)
                }
            }, onError: { error in
                print("error: ",error)
            })
            .disposed(by: disposeBag)
    }
    
    
}
