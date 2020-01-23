//
//  PopularShowsHandler.swift
//  DistilledTV
//
//  Created by Barry on 22/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation

typealias LoadPopularShowsHandler = (LoadPopularShowsResult) -> ()

enum LoadPopularShowsResult {
    case startActivity
    case stopActivity
    case successPopularShows(PopularShows)
    case successPoster(PopularShowPoster)
    case failed(APIError)
}
