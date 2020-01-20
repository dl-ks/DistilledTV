//
//  APIRouter.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation

protocol RequestConvertible {
    func urlRequest() throws -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum APIRouter {
    
    case popularTvShows(apiKey: String, page: Int)
    
    private var method: HTTPMethod {
        switch self {
        case .popularTvShows:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .popularTvShows(let apiKey, let page):
            return "/tv/popular?api_key=\(apiKey)&page=\(page)"
        }
    }
}

extension APIRouter: RequestConvertible {
    func urlRequest() throws -> URLRequest {
        
        switch self {
        case .popularTvShows:
            
            let url = Utility.movieDB.baseUrl.rawValue.appending(path)
            var urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue(Utility.contentType.json.rawValue, forHTTPHeaderField: Utility.httpHeaderField.acceptType.rawValue)
            urlRequest.setValue(Utility.contentType.json.rawValue, forHTTPHeaderField: Utility.httpHeaderField.contentType.rawValue)
            
            return urlRequest
        }
        
    }
}

class APIClient {
    
}
