//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 12.09.22.
//

import UIKit
import SnapKit

protocol SearchResultsDelegate: AnyObject {
    func searchResaltDidTapped(trailer: MovieTrailer?)
}

final class SearchResultsViewController: UIViewController {
    
    weak var delegate: SearchResultsDelegate?
    
    public var viewModel: SearchResultsProtocol = SearchResultsViewModel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10,
                                 height: 200)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "\(MovieCollectionViewCell.self)")
        
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        collectionView.delegate = self
        collectionView.dataSource = self
        bind()
        
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func setupLayouts() {
        collectionView.frame = view.bounds

    }
    
    private func bind() {
        viewModel.contentDidChanged = {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieCollectionViewCell.self)", for: indexPath) as? MovieCollectionViewCell
        cell?.setupCell(movie: viewModel.movies[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.didSelectMovie(at: indexPath) {
            self.delegate?.searchResaltDidTapped(trailer: self.viewModel.trailer)
        }
    }
    
}
