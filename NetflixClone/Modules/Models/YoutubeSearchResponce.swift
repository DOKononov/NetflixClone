//
//  YoutubeResponce.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 13.09.22.
//

import Foundation

struct YoutubeSearchResponce: Codable {
//    let kind, etag, nextPageToken, regionCode: String
//    let pageInfo: PageInfo
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let kind, etag: String
    let id: ID
}

struct ID: Codable {
    let kind, videoID, playlistID: String?

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
        case playlistID = "playlistId"
    }
}

//struct PageInfo: Codable {
//    let totalResults, resultsPerPage: Int
//}
