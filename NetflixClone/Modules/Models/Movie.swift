//
//  Movie.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 3.09.22.
//

import Foundation

struct KinopoiskResponce: Codable {
    let docs: [Movie]?
}

struct Movie: Codable {
    let poster: MoviePoster?
    let rating: MovieRating?
    let movieLength: Int?
    let id: Int
    let name, docDescription: String?
    let year: Int
    let alternativeName: String?

    enum CodingKeys: String, CodingKey {
        case poster, rating
        case movieLength, id
        case name
        case docDescription = "description"
        case year
        case alternativeName
    }
}

struct MovieName: Codable {
    let id, name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct MoviePoster: Codable {
    let id: String?
    let url, previewURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case url
        case previewURL = "previewUrl"
    }
}

struct MovieRating: Codable {
    let id: String?
    let kp, imdb: Double?
    let filmCritics: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case kp, imdb, filmCritics
    }
}
