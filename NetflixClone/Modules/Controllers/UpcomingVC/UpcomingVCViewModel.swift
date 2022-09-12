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
}

final class UpcomingVCViewModel: UpcomingVCProtocol {
 
    
    var movies: [Movie] = [] {
        didSet {
            contentDidChanged?()
        }
    }
    
    var contentDidChanged: (() -> Void)?
    
    func loadDataFromAPI() {
        NetworkService.shared.getMovies(fromYear: "2022", toYear: "2022") { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies ?? []
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
