//
//  Movie.swift
//  Movie
//
//  Created by new on 7/1/22.
//

import Foundation

struct TopLevelObj: Decodable {
    let results: [MovieInfo]
}

struct MovieInfo: Decodable {
    let title: String
    let rating: Float?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case rating = "vote_average"
        case url = "poster_path"
    }
}


