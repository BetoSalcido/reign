//
//  Result.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2019 BetoSalcido. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case failure(Error)
}

enum CodeError: Error {
    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case unsuppotedURL
}
