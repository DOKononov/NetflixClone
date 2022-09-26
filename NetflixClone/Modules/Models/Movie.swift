//
//  Movie.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 3.09.22.
//

import Foundation

struct KinopoiskResponce: Codable {
    let docs: [Movie]?
//    let total, limit, page, pages: Int
}

struct Movie: Codable {
//    let externalID: MovieExternalID
    let poster: MoviePoster?
//    let rating, votes: MovieRating
    let rating: MovieRating
    let movieLength: Int?
    let id: Int
//    let type: MovieType
    let name, docDescription: String?
    let year: Int
    let alternativeName: String?
//    let names: [MovieName]
//    let shortDescription: String?
//    let color: String?

    enum CodingKeys: String, CodingKey {
//        case externalID = "externalId"
        case poster, rating//, votes, 
        case movieLength, id//, type,
        case name
        case docDescription = "description"
        case year
        case alternativeName
//        case names, shortDescription, color
    }
}

//struct MovieExternalID: Codable {
//    let id: String
//    let imdb: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case imdb
//    }
//}

struct MovieName: Codable {
    let id, name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct MoviePoster: Codable {
    let id: String
    let url, previewURL: String

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

//enum MovieType: String, Codable {
//    case tvSeries = "tv-series"
//    case movie
//}
