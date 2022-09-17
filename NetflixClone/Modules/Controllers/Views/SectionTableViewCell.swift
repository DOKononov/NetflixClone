//
//  CollectionViewTVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 30.08.22.
//

import UIKit

class SectionTableViewCell : UITableViewCell {
    
    private var movies: [Movie] = []
    private var networkService = NetworkService.shared
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "\(MovieCollectionViewCell.self)")
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()

    func setupCell(movies: [Movie]) {
        setupViews()
        setupLayouts()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func setupViews() {
        addSubview(collectionView)
    }
    
    private func setupLayouts() {
        collectionView.frame = contentView.bounds
    }
}

extension SectionTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieCollectionViewCell.self)", for: indexPath) as? MovieCollectionViewCell
        cell?.setupCell(movie: movies[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.33, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let movieName = movies[indexPath.row].name else { return }
        networkService.getYTVideoData(for: movieName + " trailer") { result in
            switch result {
            case .success(let videoElement):
                print(videoElement.id)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
