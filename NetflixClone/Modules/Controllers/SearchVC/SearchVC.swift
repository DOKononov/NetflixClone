//
//  SearchVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 30.08.22.
//

import UIKit

final class SearchVC: UIViewController {
    
    private var viewModel: SearchVCProtocol = SearchVCViewModel()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(MovieListTableViewCell.self, forCellReuseIdentifier: "\(MovieListTableViewCell.self)")
        return table
    }()
    
    private let searchController: UISearchController = {
       let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie..."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.loadMovies()
        bind()
        searchController.searchResultsUpdater = self
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableView)
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupLayouts() {
        tableView.frame = view.bounds
    }
    
    private func bind() {
        viewModel.contentDidChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
}


extension SearchVC : UITableViewDataSource, UITableViewDelegate {
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
}


extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let movie = searchBar.text,
              !movie.trimmingCharacters(in: .whitespaces).isEmpty,
              movie.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        viewModel.loadSearchResults(for: movie) { result in
            switch result {
            case .success(let movies):
                resultsController.viewModel.movies = movies
            case .failure(let error):
                resultsController.viewModel.movies = []
                print(error.localizedDescription)
            }
        }
              
        
    }
    
    
}
