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
}

enum APIErrors: Error {
    case failedToLoadData
}

final class APICaller {
    static let shared = APICaller()
    private init(){}
    
    func getMovies(fromYear: String, toYear: String, complition: @escaping (Result<[Movie], Error>) -> Void) {
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
            catch { complition(.failure(APIErrors.failedToLoadData)) }
        }.resume()
    }
    
    
}
