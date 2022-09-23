//
//  SearchVCViewModel.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 9.09.22.
//

import Foundation

protocol SearchVCProtocol {
    var movies: [Movie] { get set }
    var contentDidChanged: (() -> Void)? { get set }
    var networkService: NetworkService { get }
    func loadMovies()
    func loadSearchResults(for movie: String, complition: @escaping ((Result<[Movie], Error>) -> Void))
}

final class SearchVCViewModel: SearchVCProtocol {
    var networkService = NetworkService()
    
    var movies: [Movie] = [] {
        didSet {
            contentDidChanged?()
        }
    }
    
    var contentDidChanged: (() -> Void)?
    
    func loadMovies() {
        networkService.getMovies(fromYear: "2000", toYear: "2022") { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let movies):
                self?.movies = movies ?? []
            }
        }
    }
    
    func loadSearchResults(for movie: String, complition: @escaping ((Result<[Movie], Error>) -> Void)) {
        networkService.serchFor(movie: movie) { result in
            switch result {
            case .success(let movies):
                complition(.success(movies))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    
}
