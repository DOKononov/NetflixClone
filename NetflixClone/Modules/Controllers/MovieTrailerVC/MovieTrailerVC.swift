//
//  MovieTrailerVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 17.09.22.
//

import UIKit
import WebKit

class MovieTrailerVC: UIViewController {
    
    private var viewModel: MovieTrailerProtocol = MovieTrailerViewModel()
    private let webView = WKWebView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(UIColor.label, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
    }
    
    private func setupViews() {
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
    }
    
    private func setupLayouts() {
        
    }
    
    
}
