//
//  APICaller.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 2.09.22.
//

import Foundation
import UIKit

//https://api.kinopoisk.dev/movie?field=rating.kp&search=7-10&token=ZQQ8GMN-TN54SGK-NB3MKEC-ZKB8V06

struct Constance {
    static let API_KEY = "ZQQ8GMN-TN54SGK-NB3MKEC-ZKB8V06"
    static let baseURL = "https://api.kinopoisk.dev/movie"
    static let youtubeAPI_KEY = "AIzaSyDSKUtZZzm0YnUXwqeWE4E5c4cyBcwkD4A"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIErrors: Error {
    case failedToLoadData
    case movieTrailerError
}

final class NetworkService {
    
    func getMovies(fromYear: String, toYear: String, complition: @escaping (Result<[Movie]?, Error>) -> Void) {
        guard let url = URL(string: Constance.baseURL
                            + "?field=rating.kp&search=7-10"
                            + "&field=year&search="+fromYear+"-"+toYear
                            + "&field=typeNumber&search=2"
                            + "&sortField=year&sortType=1"
                            + "&sortField=votes.imdb&sortType=-1"
                            + "&token=" +  Constance.API_KEY) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(KinopoiskResponce.self, from: data)
                DispatchQueue.main.async {
                    complition(.success(result.docs))
                }
            }
            catch {
                complition(.failure(APIErrors.failedToLoadData))
            }
        }.resume()
    }
    
    func serchFor(movie: String, complition: @escaping (Result<[Movie], Error>) -> Void) {
        let str = (Constance.baseURL
                + "?search="
                + movie
                + "&field=name"
                + "&isStrict=false"
                + "&token=" + Constance.API_KEY)
                
        guard let url = URL(string: str) else { return }
        URLSession.shared.dataTask(with: url) { data, resonce, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(KinopoiskResponce.self, from: data)
                DispatchQueue.main.async {
                    complition(.success(result.docs ?? []))
                }
            }
            catch {
                complition(.failure(error))
            }
        }.resume()
    }
    
    func getYTVideoData(for movie: Movie, complition: @escaping (Result<MovieTrailer, Error>) -> Void) {
        guard let movieName = movie.name?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constance.youtubeBaseURL)q=\(movieName)&key=\(Constance.youtubeAPI_KEY)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(YoutubeSearchResponce.self, from: data)
                if let movieTrailer = self.makeMovieTrailerModel(movie: movie, youtubeSearch: result){
                    complition(.success(movieTrailer))
                } else {
                    complition(.failure(APIErrors.movieTrailerError))
                }
            }
            catch {
                complition(.failure(error))
            }
        }.resume()
    }
    
    private func makeMovieTrailerModel(movie: Movie, youtubeSearch: YoutubeSearchResponce) -> MovieTrailer? {
        guard let element = youtubeSearch.items.first else {return nil}
        return MovieTrailer(name: movie.name ?? "no name",
                            description: movie.docDescription ?? "no description",
                            videoElement: element)
    }
    
    
}
