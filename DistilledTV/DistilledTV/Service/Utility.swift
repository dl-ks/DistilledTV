//
//  Utility.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation

struct Utility {
    
    enum movieDB: String {
        case apiKeyV3 = "e71f6478fc8d264482c0044d33ec08c6"
        case baseUrl = "https://api.themoviedb.org/3"
        case imageUrl = "https://image.tmdb.org/t/p/w500"
    }
    
    enum httpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum contentType: String {
        case json = "application/json"
        case image = "image/jpg"
    }
    
}
