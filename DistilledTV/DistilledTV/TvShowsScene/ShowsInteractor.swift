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
    case successPopularShows([Show])
    case failed(Error)
}

protocol ShowsInteractor {
    func loadShows(page: Int, then handler: @escaping LoadShowsHandler)
}

class ShowsDefaultInteractor: ShowsInteractor {
    func loadShows(page: Int, then handler: @escaping LoadShowsHandler) {
        APIClient.shared.loadPopularTvShows(page: page, { result in
            switch result {
            case .success(let popular):
                handler(.successPopularShows(popular.results))
            case .failure(let error):
                handler(.failed(error))
            }
        })
    }
}
