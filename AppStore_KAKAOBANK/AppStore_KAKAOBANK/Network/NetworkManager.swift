//
//  NetworkManager.swift
//  AppStore_KAKAOBANK
//
//  Created by 이찬호 on 2023/03/19.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class NetworkManager {
    
    static func getSearchData(url: String, param: [String: Any]) -> Observable<Result<SearchResultModel, Error>> {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
        ]
        
        return Observable.create { observer -> Disposable in
            
            AF.request(url, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        if let decodedData = try? decoder.decode(SearchResultModel.self, from: data) {
                            observer.onNext(.success(decodedData))
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                    
                }
                return Disposables.create()
        }
    }
    
  
  
}
