//
//  TvShowsInteractor.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation

protocol PopularShowsInteractor {
    func loadShows(page: Int, then handler: @escaping LoadPopularShowsHandler)
    func loadPoster(for show: PopularShow, then handler: @escaping LoadPopularShowsHandler) -> PopularShowPoster?
    func sort(shows: [PopularShow]) -> [PopularShow]
}

class PopularShowsDefaultInteractor {
    
    var imageCache = [String: Data]()
    var apiClient: PopularShowsLoadable
    
    init(apiClient: PopularShowsLoadable) {
        self.apiClient = apiClient
    }
    
    func cache(_ image: Data?, for path: String) {
        guard let image = image else { return }
        imageCache[path] = image
    }
}

extension PopularShowsDefaultInteractor: PopularShowsInteractor {
    
    func loadShows(page: Int, then handler: @escaping LoadPopularShowsHandler) {
        handler(.startActivity)
        apiClient.loadPopularShows(page: page, { result in
            handler(.stopActivity)
            switch result {
            case .success(let popular):
                handler(.successPopularShows(popular))
            case .failure(let error):
                handler(.failed(error))
            }
        })
    }
    
    func loadPoster(for show: PopularShow, then handler: @escaping LoadPopularShowsHandler) -> PopularShowPoster? {
        if let posterPath = show.posterPath, let image = imageCache[posterPath] {
            return PopularShowPoster(show: show, image: image)
        } else {
            apiClient.loadPoster(for: show, { [weak self] result in
                switch result {
                case .success(let poster):
                    self?.cache(poster, for: show.posterPath ?? "")
                    handler(.successPoster(PopularShowPoster(show: show, image: poster)))
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
}
