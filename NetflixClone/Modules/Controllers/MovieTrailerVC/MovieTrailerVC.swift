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
    
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "titleLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "overviewLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(UIColor.label, for: .normal)
        button.layer.cornerRadius =  8
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
    }
    
    func setupVC(for trailer: MovieTrailer) {
        self.titleLabel.text = trailer.name
        self.overviewLabel.text = trailer.description
        
        
        guard let videoID = trailer.videoElement.id.videoID else { return }
        let str = "https://www.youtube.com/embed/\(videoID)"
        print(str)
        guard let url = URL(string: str) else { return }
        
        webView.load(URLRequest(url: url))
        
        
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
    }
    
    private func setupLayouts() {
        webView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16 )
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(overviewLabel.snp.bottom).offset(16)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
    }
    
    
}
