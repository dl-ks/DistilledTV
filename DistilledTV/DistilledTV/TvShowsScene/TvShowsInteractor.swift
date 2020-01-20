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
     
}

protocol TvShowsInteractor {
    func loadTvShows(page: Int, then handler: LoadTvShowsHandler)
}

class TvShowsDefaultInteractor: TvShowsInteractor {
    func loadTvShows(page: Int, then handler: LoadTvShowsHandler) {
        
    }
}
