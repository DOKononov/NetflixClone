//
//  UpcomingVCViewModel.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 8.09.22.
//

import Foundation

protocol UpcomingVCProtocol {
    var movies: [Movie] { get set }
    var contentDidChanged: (() -> Void)? { get set }
    func loadDataFromAPI()
    func didSelectMovie(at indexPath: IndexPath, complition: @escaping () -> Void) 
    var trailer: MovieTrailer? { get set }
}

final class UpcomingVCViewModel: UpcomingVCProtocol {
 
    var trailer: MovieTrailer?
    var networkService = NetworkService()
    var movies: [Movie] = [] {
        didSet {
            contentDidChanged?()
        }
    }
    
    var contentDidChanged: (() -> Void)?
    
    func loadDataFromAPI() {
        networkService.getMovies(fromYear: "2022", toYear: "2022") { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies ?? []
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didSelectMovie(at indexPath: IndexPath, complition: @escaping () -> Void) {
        let movie = movies[indexPath.row]
        networkService.getYTVideoData(for: movie) { [weak self] result in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
            case.success(let trailer):
                self?.trailer = trailer
                complition()
            }
        }
    }
    
}
