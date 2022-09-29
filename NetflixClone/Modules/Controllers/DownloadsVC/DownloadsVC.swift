//
//  DownloadsVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 30.08.22.
//

import UIKit

final class DownloadsVC: UIViewController {
    
    private var viewModel: DownloadVCProtocol = DownloadVCViewModel()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MovieListTableViewCell.self, forCellReuseIdentifier: "\(MovieListTableViewCell.self)")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayouts()
        bind()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.fetchMovies()
        viewModel.addObserver()
    }
    
    private func bind() {
        viewModel.contentDidChanged = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    


    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        view.addSubview(tableView)
    }

    
    private func setupLayouts() {
        tableView.frame = view.bounds
    }
}


extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MovieListTableViewCell.self)", for: indexPath) as? MovieListTableViewCell
        
        cell?.setupCell(with: viewModel.movies[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieListTableViewCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel.deleteMovie(at: indexPath)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectMovie(at: indexPath) { [weak self] in
            DispatchQueue.main.async {
                let vc = MovieTrailerVC()
                vc.setupVC(for: self?.viewModel.trailer)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
