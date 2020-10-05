//
//  HomeDataModel.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import Foundation
import Reachability

protocol HomeDataModelDelegate {
    func didReceiveData(response: HackerNews)
    func didFail(error: CodeError)
}

class HomeDataModel {
    private let urlRequest: String = "http://hn.algolia.com/api/v1/search_by_date?query=ios"
    private let reachability = try! Reachability()
    
    var homeRequest = HomeRequest(apiRequest: ApiRequest.shared)
    var delegate: HomeDataModelDelegate?
    
    func getData() {
        if reachability.connection != .unavailable {
            homeRequest.getData(url: urlRequest) {  [weak self] (response) in
                guard let strongSelf = self else{ return }
                switch response {
                case .success(let response):
                    guard let data = response else {
                        strongSelf.delegate?.didFail(error: .invalidResponse)
                        return
                    }
                    strongSelf.saveResponse(data: data)
                    strongSelf.delegate?.didReceiveData(response: data)
                case .failure(let error):
                    print("the error \(error.localizedDescription)")
                    strongSelf.delegate?.didFail(error: .invalidResponse)
                }
            }
        } else {
            isResponseSaved()
        }

    }
    
    //This is not the best way to manage the offline mode. I would prefer save it in a local file with life time of 24 hrs.
    private func saveResponse(data: HackerNews) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "hackerNews")
        }
    }

    private func isResponseSaved() {
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "hackerNews") as? Data {
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(HackerNews.self, from: data) {
                delegate?.didReceiveData(response: data)
            } else {
                delegate?.didFail(error: .invalidResponse)
            }
        } else {
             delegate?.didFail(error: .connectionError)
        }
    }

}
