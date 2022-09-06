//
//  HomeVCViewModel.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 6.09.22.
//

import Foundation

protocol HomeVCProtocol {
    var movies: [[Movie]] { get set }
    var contentDidChanged: (() -> Void)? { get set }
    
}

final class HomeVCViewModel: HomeVCProtocol {
    var movies: [[Movie]] = [] {
        didSet {
            contentDidChanged?()
        }
    }
    
    var contentDidChanged: (() -> Void)?
    
    
}
