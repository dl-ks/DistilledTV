//
//  TvShowsInteractor.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation

typealias LoadPopularShowsHandler = (LoadPopularShowsResult) -> ()

enum LoadPopularShowsResult {
    case startActivity
    case stopActivity
    case successPopularShows(PopularShows)
    case successPoster(ShowPoster)
    case failed(Error)
}

protocol PopularShowsInteractor {
    func loadShows(page: Int, then handler: @escaping LoadPopularShowsHandler)
    func loadPoster(for show: Show, then handler: @escaping LoadPopularShowsHandler) -> ShowPoster?
}

class PopularShowsDefaultInteractor: PopularShowsInteractor {
    
    var imageCache = [String: Data]()
    var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    public func loadShows(page: Int, then handler: @escaping LoadPopularShowsHandler) {
        
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
    
    public func loadPoster(for show: Show, then handler: @escaping LoadPopularShowsHandler) -> ShowPoster? {
        
        if let image = imageCache[show.posterPath] {
            return ShowPoster(show: show, image: image)
        } else {
            apiClient.loadPoster(for: show, { [weak self] result in
                switch result {
                case .success(let poster):
                    self?.cache(poster, for: show.posterPath)
                    let showPoster = ShowPoster(show: show, image: poster)
                    handler(.successPoster(showPoster))
                case .failure(let error):
                    print(error)
                }
            })
            return nil
        }
    }
    
    private func cache(_ image: Data?, for path: String) {
        guard let image = image else { return }
        imageCache[path] = image
    }
}
