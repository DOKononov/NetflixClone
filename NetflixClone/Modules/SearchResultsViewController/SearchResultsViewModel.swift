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
}

final class SearchResultsViewModel: SearchResultsProtocol {
    var movies: [Movie] = [] {
        didSet {
            contentDidChanged?()
        }
    }
    
    var contentDidChanged: (() -> Void)?
    
    
}
