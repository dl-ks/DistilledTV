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
    func loadPoster(for show: Show, then handler: @escaping LoadPopularShowsHandler) -> ShowPoster?
    func sortShows(_ shows: [Show]) -> [Show]
}

class PopularShowsDefaultInteractor {
    
    var imageCache = [String: Data]()
    var apiClient: PopularShowsLoadable
    
    init(apiClient: PopularShowsLoadable) {
        self.apiClient = apiClient
    }
    
    private func cache(_ image: Data?, for path: String) {
        guard let image = image else { return }
        imageCache[path] = image
    }
}

extension PopularShowsDefaultInteractor: PopularShowsInteractor {
    
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
    
    func sortShows(_ shows: [Show]) -> [Show] {
        return [Show]()
    }
}
