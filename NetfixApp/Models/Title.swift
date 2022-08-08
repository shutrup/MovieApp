//
//  Movies.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 03.08.2022.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results:[Title]
}

struct Title: Codable {
    let id: Int?
    let name: String?
    let titleRu: String?
    let originalTitle, overview, posterPath: String?
    let genreIDS: [Int]?
    let mediaType: String?
    let releaseDate: String?
    let voteCount: Int?
    let originalName: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case titleRu = "title"
            case originalTitle = "original_title"
            case overview
            case posterPath = "poster_path"
            case mediaType = "media_type"
            case releaseDate = "release_date"
            case genreIDS = "genre_ids"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case originalName = "original_name"
        }
}

