//
//  UpcomingVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 30.08.22.
//

import UIKit

final class UpcomingVC: UIViewController {
    
    private var viewModel: UpcomingVCProtocol = UpcomingVCViewModel()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: "\(UpcomingTableViewCell.self)")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        tableView.delegate = self
        tableView.dataSource = self
        bind()
        viewModel.loadDataFromAPI()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
    }
    
    private func setupLayouts() {
        tableView.frame = view.bounds
    }
    
    private func bind() {
        viewModel.contentDidChanged = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}


extension UpcomingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UpcomingTableViewCell.self)", for: indexPath) as? UpcomingTableViewCell
        cell?.setupCell(with: viewModel.movies[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
