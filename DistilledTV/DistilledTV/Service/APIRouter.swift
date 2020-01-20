//
//  APIRouter.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation

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
            return ""
        }
    }
    
}
