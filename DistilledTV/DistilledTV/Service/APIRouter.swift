//
//  APIRouter.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

protocol RequestConvertible {
    func urlRequest() -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum APIError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

enum APIRouter {
    
    case popularTvShows(apiKey: String, page: Int)
    case poster(apiKey: String, fileName: String)
    
    private var method: HTTPMethod {
        switch self {
        case .popularTvShows,
             .poster:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .popularTvShows(let apiKey, let page):
            return "/tv/popular?api_key=\(apiKey)&page=\(page)"
        case .poster(let apiKey, let fileName):
            return "\(fileName)?api_key=\(apiKey)"
        }
    }
}

extension APIRouter: RequestConvertible {
    func urlRequest() -> URLRequest {
        
        switch self {
        case .popularTvShows:
            let url = Utility.movieDB.baseUrl.rawValue.appending(path)
            var urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue(Utility.contentType.json.rawValue, forHTTPHeaderField: Utility.httpHeaderField.acceptType.rawValue)
            urlRequest.setValue(Utility.contentType.json.rawValue, forHTTPHeaderField: Utility.httpHeaderField.contentType.rawValue)
            return urlRequest
            
        case .poster:
            let url = Utility.movieDB.imageUrl.rawValue.appending(path)
            var urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue(Utility.contentType.image.rawValue, forHTTPHeaderField: Utility.httpHeaderField.acceptType.rawValue)
            urlRequest.setValue(Utility.contentType.json.rawValue, forHTTPHeaderField: Utility.httpHeaderField.contentType.rawValue)
            return urlRequest
        }
    }
}

class APIClient {
    
    let session = URLSession.shared
    public static let shared = APIClient()
    private init() {}
    
    private func load<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = request.url, var _ = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        session.dataTask(with: request) { (data, response, error)  in
            
            if let _ = error {
                completion(.failure(.apiError))
            } else if let data = data, let response = response {
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                do {
                    let values = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(values))
                } catch let e {
                    print(e)
                    completion(.failure(.decodeError))
                }
                
            }
        }.resume()
    }
    
    private func loadImage(request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = request.url, var _ = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        session.dataTask(with: request) { (data, response, error)  in
            
            if let _ = error {
                completion(.failure(.apiError))
            } else if let data = data, let response = response {
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                completion(.success(data))
            }
        }.resume()
    }
}

protocol PopularShowsLoadable {
    func loadPopularShows(page: Int, _ result: @escaping (Result<PopularShows, APIError>) -> Void)
    func loadPoster(for show: PopularShow, _ result: @escaping (Result<Data, APIError>) -> Void)
}

extension APIClient: PopularShowsLoadable {
    func loadPopularShows(page: Int, _ result: @escaping (Result<PopularShows, APIError>) -> Void) {
        let request = APIRouter.popularTvShows(apiKey: Utility.movieDB.apiKeyV3.rawValue, page: page).urlRequest()
        load(request: request, completion: result)
    }
    
    func loadPoster(for show: PopularShow, _ result: @escaping (Result<Data, APIError>) -> Void) {
        let request = APIRouter.poster(apiKey: Utility.movieDB.apiKeyV3.rawValue, fileName: show.posterPath ?? "").urlRequest()
        loadImage(request: request, completion: result)
    }
}
