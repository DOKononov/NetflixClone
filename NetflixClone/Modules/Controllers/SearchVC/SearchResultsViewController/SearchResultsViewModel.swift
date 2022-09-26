//
//  SearchResultsViewModel.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 12.09.22.
//

import Foundation

protocol SearchResultsProtocol {
    var movies: [Movie] { get set }
    var contentDidChanged: (() -> Void)? { get set }
    var trailer: MovieTrailer? { get set }
    func didSelectMovie(at indexpath: IndexPath, complition: @escaping (()-> Void))
}

final class SearchResultsViewModel: SearchResultsProtocol {
    var trailer: MovieTrailer?
    let networkService = NetworkService()
    
    var movies: [Movie] = [] {
        didSet {
            contentDidChanged?()
        }
    }
    
    var contentDidChanged: (() -> Void)?
    
    func didSelectMovie(at indexpath: IndexPath, complition: @escaping (() -> Void)) {
        let movie = movies[indexpath.row]
        networkService.getYTVideoData(for: movie) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let trailer):
                self?.trailer = trailer
                complition()
            }
        }
    }
    
}
