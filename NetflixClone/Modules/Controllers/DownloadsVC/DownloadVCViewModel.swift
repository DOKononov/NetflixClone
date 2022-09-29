//
//  DownloadVCViewModel.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 29.09.22.
//

import Foundation

protocol DownloadVCProtocol {
    var movies: [MovieEntity] {get set}
    var contentDidChanged: (() -> Void)? {get set}
    var trailer: MovieTrailer? {get set}
    func fetchMovies()
    func deleteMovie(at indexPath: IndexPath)
    func addObserver()
    func didSelectMovie(at indexPath: IndexPath, complition: @escaping () -> Void)
}

final class DownloadVCViewModel: DownloadVCProtocol {
    private var networkService = NetworkService()
    private var coreDataService = CoreDataService.shared
    var trailer: MovieTrailer?
    var movies: [MovieEntity] = [] {
        didSet {
            contentDidChanged?()
        }
    }
    
    var contentDidChanged: (() -> Void)?
    
    func fetchMovies() {
        coreDataService.fetchData { result in
            switch result {
            case .success(let movies):
                self.movies = movies
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteMovie(at indexPath: IndexPath) {
        coreDataService.delete(movieEntity: movies[indexPath.row]) { [weak self] result in
            switch result {
            case .success():
                self?.movies.remove(at: indexPath.row)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchMovies()
        }
    }
    
    func didSelectMovie(at indexPath: IndexPath, complition: @escaping () -> Void) {
        let movieEntity = movies[indexPath.row]
        let movie = coreDataService.convert(movieEntity: movieEntity)
        
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
