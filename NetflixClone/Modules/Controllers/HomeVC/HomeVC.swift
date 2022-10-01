//
//  HomeVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 30.08.22.
//

import UIKit

final class HomeVC: UIViewController {
    
    private var viewModel: HomeVCProtocol = HomeVCViewModel()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SectionTableViewCell .self, forCellReuseIdentifier: "\(SectionTableViewCell .self)")
        return table
    }()
    
    private let headerView: HeaderView = {
        let view = HeaderView(frame: CGRect(x: 0, y: 0,
                                            width: UIScreen.main.bounds.width,
                                            height: 450))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.loadDataFromAPI()
        setupViews()
        setupLayouts()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
        viewModel.getRandomMovie()
        bind()

    }
    
    private func bind() {
        viewModel.contentDidChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.randomMovieDidSet = { [weak self] in
            DispatchQueue.main.async {
                self?.headerView.setupView(for: self?.viewModel.randomHeaderMovie)
            }
            
        }
    }

    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
    }
    
    
    private func setupLayouts() {
        tableView.frame = view.bounds
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "n.circle.fill"), style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = leftBarButton
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
    }
    
}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        header.frame = CGRect(x: header.bounds.origin.x + 20,
                              y: header.bounds.origin.y,
                              width: header.bounds.width,
                              height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SectionTableViewCell .self)", for: indexPath) as? SectionTableViewCell
        cell?.delegate = self
        viewModel.setupCollectionViewTableViewCell(indexPath: indexPath, cell: cell)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


extension HomeVC: SectionTableViewCellDelegate {
    func cellDidTapped(_ cell: SectionTableViewCell, trailerModel: MovieTrailer) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.transform = .identity
            let vc = MovieTrailerVC()
            vc.setupVC(for: trailerModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
