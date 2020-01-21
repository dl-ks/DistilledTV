//
//  TvShowsInteractor.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation

typealias LoadShowsHandler = (LoadShowsResult) -> ()

enum LoadShowsResult {
    case startActivity
    case stopActivity
    case successPopularShows(PopularShows)
    case successPoster(ShowPoster)
    case failed(Error)
}

protocol ShowsInteractor {
    func loadShows(page: Int, then handler: @escaping LoadShowsHandler)
    func loadPoster(for show: Show, then handler: @escaping LoadShowsHandler) -> ShowPoster?
}

class ShowsDefaultInteractor: ShowsInteractor {
    
    var imageCache = [String: Data]()
    
    public func loadShows(page: Int, then handler: @escaping LoadShowsHandler) {
        
        handler(.startActivity)
        
        APIClient.shared.loadPopularShows(page: page, { result in
            handler(.stopActivity)
            switch result {
            case .success(let popular):
                handler(.successPopularShows(popular))
            case .failure(let error):
                handler(.failed(error))
            }
        })
    }
    
    public func loadPoster(for show: Show, then handler: @escaping LoadShowsHandler) -> ShowPoster? {
        
        if let image = imageCache[show.posterPath] {
            return ShowPoster(show: show, image: image)
        } else {
            APIClient.shared.loadPoster(for: show, { [weak self] result in
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
