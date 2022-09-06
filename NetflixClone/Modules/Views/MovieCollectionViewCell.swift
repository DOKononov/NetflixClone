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
    
    private let activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
    }()
    
    func setupCell(movie: Movie) {
        setupViews()
        setupLayouts()
        setImage(movie: movie)
        activityIndicator.startAnimating()
    }
    
    private func setupViews() {
        addSubview(posterImageView)
        addSubview(activityIndicator)
    }
    
    private func setupLayouts() {
        posterImageView.frame = contentView.bounds
        activityIndicator.frame = contentView.bounds
    }
    
    private func setImage(movie: Movie) {
        let url = URL(string: movie.poster.previewURL)
        posterImageView.sd_setImage(with: url ) { _,_,_,_  in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
}
