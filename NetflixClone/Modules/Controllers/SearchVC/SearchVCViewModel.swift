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
}

final class SearchVCViewModel: SearchVCProtocol {
    var networkService: NetworkService = NetworkService.shared
    
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
    
    
}
