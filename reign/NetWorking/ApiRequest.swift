//
//  ApiRequest.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import Foundation

class ApiRequest {
    static let shared = ApiRequest()
    private init() {}
    
    func get<T: Decodable>(url: String, decode:  @escaping (Decodable) -> T?, completion:  @escaping(Response<T>) -> Void) {
        
        let task = requestGet(url: url, decodingType: T.self) { (response, error) in
            guard let response = response else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CodeError.invalidResponse))
                }
                return
            }
            if let value = decode(response) {
                completion(.success(value))
            } else {
                completion(.failure(CodeError.invalidResponse))
            }
        }
        
        task.resume()
    }
}

private extension ApiRequest {
    typealias JSONTaskCompletionHandler = (Decodable?, Error?) -> Void
        
    func requestGet<T: Decodable>(url: String, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let jsonUrlString = url
        guard let URL = URL(string: jsonUrlString) else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("identity", forHTTPHeaderField: "Accept-Encoding")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(decodingType, from: data)
                        completion(response, error)
                    } catch {
                        completion(nil, error)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        return task
    }
}
