//
//  TvShowsInteractor.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation

typealias LoadTvShowsHandler = (LoadTvShowsResult) -> ()

enum LoadTvShowsResult {
    case successPopularTvShows([TvShow])
    case failed(Error)
}

protocol TvShowsInteractor {
    func loadTvShows(page: Int, then handler: @escaping LoadTvShowsHandler)
}

class TvShowsDefaultInteractor: TvShowsInteractor {
    func loadTvShows(page: Int, then handler: @escaping LoadTvShowsHandler) {
        APIClient.shared.loadPopularTvShows(page: page, { result in
            switch result {
            case .success(let popular):
                handler(.successPopularTvShows(popular.results))
            case .failure(let error):
                handler(.failed(error))
            }
        })
    }
}
