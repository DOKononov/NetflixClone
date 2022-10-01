//
//  UpcomingTableViewCell.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 8.09.22.
//

import UIKit
import SnapKit

final class MovieListTableViewCell: UITableViewCell {
    
    static let rowHeight: CGFloat = 150
    
    private let upcomingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "play.circle",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupCell(with movie: Movie) {
        setupViews()
        setupLayouts()
        loadImage(for: movie)
        titleLabel.text = movie.name
    }
    
    func setupCell(with entity: MovieEntity) {
        setupViews()
        setupLayouts()
        loadImage(for: entity.moviePosterEntity?.previewURL)
        titleLabel.text = entity.name
    }
    
    private func setupViews() {
        addSubview(upcomingImageView)
        addSubview(titleLabel)
        addSubview(playButton)
    }
    
    private func setupLayouts() {
        upcomingImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(upcomingImageView.snp.trailing).offset(16)
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(playButton.snp.leading).offset(-16)
            make.top.greaterThanOrEqualToSuperview().offset(16)
            make.bottom.greaterThanOrEqualToSuperview().offset(-16)
        }
        
        playButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(playButton.snp.height)
        }
    }
    
    private func loadImage(for movie: Movie) {
        guard let poster = movie.poster?.url, let url = URL(string: poster) else { return }
        upcomingImageView.sd_setImage(with: url)
    }
    
    private func loadImage(for urlStr: String?) {
        guard let str = urlStr, let url = URL(string: str) else {return}
        upcomingImageView.sd_setImage(with: url)
    }
    
}
