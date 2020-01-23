//
//  File.swift
//  DistilledTV
//
//  Created by Barry on 20/01/2020.
//  Copyright © 2020 dl-ks. All rights reserved.
//

import Foundation
import UIKit

struct PopularShow: Codable {
    var posterPath: String
    var popularity: Double
    var id: Int
    var overview: String
    var originCountry: [String]
    var name: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        popularity = try container.decode(Double.self, forKey: .popularity)
        id = try container.decode(Int.self, forKey: .id)
        overview = try container.decode(String.self, forKey: .overview)
        originCountry = try container.decode([String].self, forKey: .originCountry)
        name = try container.decode(String.self, forKey: .name)
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity
        case id
        case overview
        case originCountry = "origin_country"
        case name
    }
}

struct PopularShows: Codable {
    
    let page: Int
    let results: [PopularShow]
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

public struct PopularShowPoster: Codable {
    let show: PopularShow
    let image: Data
}
