//
//  TvShowsInteractor.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

protocol PopularShowsInteractor {
    func loadShows(page: Int, then handler: @escaping LoadPopularShowsHandler)
    func loadPoster(for show: PopularShow, then handler: @escaping LoadPopularShowsHandler) -> PopularShowPoster?
    func sort(shows: [PopularShow]) -> [PopularShow]
    func cache(image: UIImage?, for path: String)
}

final class PopularShowsDefaultInteractor {
    var imageCache = [String: UIImage]()
    var network: PopularShowsLoadable
    
    init(network: PopularShowsLoadable) {
        self.network = network
    }
}

extension PopularShowsDefaultInteractor: PopularShowsInteractor {
    
    func loadShows(page: Int, then handler: @escaping LoadPopularShowsHandler) {
        network.loadPopularShows(page: page, responseHandler: { result in
            switch result {
            case .success(let popularShows):
                handler(.successPopularShows(popularShows))
            case .failure(let error):
                handler(.failed(error))
            }
        })
    }
    
    func loadPoster(for show: PopularShow, then handler: @escaping LoadPopularShowsHandler) -> PopularShowPoster? {
        
        guard let posterPath = show.posterPath else {
            return nil
        }
        
        if let image = imageCache[posterPath] {
            return PopularShowPoster(show: show, image: image)
        }
        else {
            network.loadPoster(for: show, responseHandler: { result  in
                switch result {
                case .success(let image):
                    handler(.successPoster(PopularShowPoster(show: show, image: image)))
                case .failure(let error):
                    handler(.failed(error))
                }
            })
            return nil
        }
    }
    
    func sort(shows: [PopularShow]) -> [PopularShow] {
        return shows.sorted { $0.name < $1.name }
    }
    
    func cache(image: UIImage?, for path: String) {
        guard let image = image else { return }
        imageCache[path] = image
    }
}

