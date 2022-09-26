//
//  CollectionViewTVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 30.08.22.
//

import UIKit

protocol SectionTableViewCellDelegate: AnyObject {
    func cellDidTapped(_ cell: SectionTableViewCell, trailerModel: MovieTrailer)
}

class SectionTableViewCell : UITableViewCell {
    
    weak var delegate: SectionTableViewCellDelegate?
    
    private var movies: [Movie] = []
    private var networkService = NetworkService()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "\(MovieCollectionViewCell.self)")
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private func downloadDidTapped(at indexPath: IndexPath) {
        CoreDataService.shared.download(for: movies[indexPath.row]) { result in
            switch result {
            case .success():
                print("succcess")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

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
        
        let movie = movies[indexPath.row]
        
        networkService.getYTVideoData(for: movie) { [weak self] result in
            switch result {
            case .success(let trailer):
                guard let strongSelf = self else { return }
                self?.delegate?.cellDidTapped(strongSelf, trailerModel: trailer)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download",
                                          image: nil,
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          state: .off) { _ in
                self?.downloadDidTapped(at: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    

}
