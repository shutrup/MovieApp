//
//  Genres.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 06.08.2022.
//

import Foundation

struct GenresByMovie: Codable {
    let genres: [Genre]?
}


struct Genre: Codable {
    let id: Int?
    let name: String?
}
