//
//  PopularShowsClient.swift
//  DistilledTV
//
//  Created by Barry on 25/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

typealias PopularShowsResponseHandler = (Result<PopularShows, LoadingError>) -> Void
typealias PosterResponseHandler = (Result<UIImage, LoadingError>) -> Void

protocol PopularShowsLoadable {
    func loadPopularShows(page: Int, responseHandler: @escaping PopularShowsResponseHandler)
    func loadPoster(for show: PopularShow, responseHandler: @escaping PosterResponseHandler)
}

class PopularShowsClient: PopularShowsLoadable {
    
    func loadPopularShows(page: Int, responseHandler: @escaping PopularShowsResponseHandler) {
        let urlString = "\(Utility.movieDB.baseUrl.rawValue)/tv/popular?api_key=\(Utility.movieDB.apiKeyV3.rawValue)&page=\(page)"
        let resource = Resource<PopularShows>(method: .get, url: URL(string: urlString)!)
              
        Networking().load(resource: resource, responseHandler: { result in
            responseHandler(result)
        })
    }
    
    func loadPoster(for show: PopularShow, responseHandler: @escaping PosterResponseHandler) {
        let urlString = "\(Utility.movieDB.imageUrl.rawValue)\(show.posterPath ?? "")?api_key=\(Utility.movieDB.apiKeyV3.rawValue)"
        let posterResource = ImageResource(imageUrl: URL(string: urlString)!)
        
        Networking().loadImage(resource: posterResource, responseHandler: { result  in
            responseHandler(result)
        })
    }
}
