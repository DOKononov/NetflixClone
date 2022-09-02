//
//  CollectionViewTVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 30.08.22.
//

import UIKit
import SnapKit

class CollectionViewTVC: UITableViewCell {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()

    func setupCell() {
        contentView.backgroundColor = .systemPink
        setupViews()
        setupLayouts()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupViews() {
        addSubview(collectionView)
    }
    
    private func setupLayouts() {
        collectionView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
}

extension CollectionViewTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.33, height: collectionView.frame.height)
    }
}
