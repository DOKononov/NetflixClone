//
//  MovieCollectionViewCell.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 5.09.22.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
        
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    func setupCell(movie: Movie) {
        setupViews()
        setupLayouts()
        setImage(movie: movie)
    }
    
    private func setupViews() {
        addSubview(posterImageView)
    }
    
    private func setupLayouts() {
        posterImageView.frame = contentView.bounds
    }
    
    private func setImage(movie: Movie) {
        let url = URL(string: movie.poster.previewURL)
        posterImageView.sd_setImage(with: url ) { image, error, _, _ in
            
        }
    }
    
}
