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
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
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
        if let poster = movie.poster?.previewURL {
            
            let url = URL(string: poster)
            posterImageView.sd_setImage(with: url ) { _,_,_,_  in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        } else {
            activityIndicator.stopAnimating()
            posterImageView.image = UIImage(named: "imagePlaceholder")
        }
    }
    
}
