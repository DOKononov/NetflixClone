//
//  APICaller.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 2.09.22.
//

import Foundation
import UIKit

//https://api.kinopoisk.dev/movie?field=rating.kp&search=7-10&token=ZQQ8GMN-TN54SGK-NB3MKEC-ZKB8V06
//movie?field=rating.kp&search=7-10&field=year&search=2017-2020&field=typeNumber&search=2&sortField=year&sortType=1&sortField=votes.imdb&sortType=-1&token=ZQQ8GMN-TN54SGK-NB3MKEC-ZKB8V06

struct Constance {
    static let API_KEY = "ZQQ8GMN-TN54SGK-NB3MKEC-ZKB8V06"
    static let baseURL = "https://api.kinopoisk.dev/movie"
    static let youtubeAPI_KEY = "AIzaSyDSKUtZZzm0YnUXwqeWE4E5c4cyBcwkD4A"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIErrors: Error {
    case failedToLoadData
}

final class NetworkService {
    static let shared = NetworkService()
    private init(){}
    
    func getMovies(fromYear: String, toYear: String, complition: @escaping (Result<[Movie]?, Error>) -> Void) {
        guard let url = URL(string: Constance.baseURL
                            + "?field=rating.kp&search=7-10"
                            + "&field=year&search="+fromYear+"-"+toYear
                            + "&field=typeNumber&search=2"
                            + "&sortField=year&sortType=1"
                            + "&sortField=votes.imdb&sortType=-1"
                            + "&token=" +  Constance.API_KEY) else { return }
        print("KP url:  \(url)")
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
        
        print(url)
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
    
    func getYTVideoData(for movie: String, complition: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let movie = movie.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constance.youtubeBaseURL)q=\(movie)&key=\(Constance.youtubeAPI_KEY)") else { return }
        
        print("YT url: \(url)")
        URLSession.shared.dataTask(with: url) { data, responce, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(YoutubeSearchResponce.self, from: data)
                complition(.success(result.items[0]))
            }
            
            catch {
                complition(.failure(error))
//                print(error.localizedDescription)
            }

        }.resume()
        
    }
    
    
}
