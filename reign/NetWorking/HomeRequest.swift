//
//  HomeRequest.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import Foundation

class HomeRequest {
    var apiRequest: ApiRequest
    
    init(apiRequest: ApiRequest) {
        self.apiRequest = apiRequest
    }
    
    func getData(url: String, completion: @escaping(Response<HackerNews?>) -> Void ) {
        apiRequest.get(url: url, decode: { (response) -> HackerNews? in
            guard let data = response as? HackerNews else {
                return nil
            }
            return data
        }, completion: completion)
    }
}
