//
//  HomeVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 30.08.22.
//

import UIKit
import SnapKit

enum Sections: Int {
    case trendingMovies = 0
    case trendingTV = 1
    case popular = 2
    case upcomingMovies = 3
    case topRated = 4
}

final class HomeVC: UIViewController {
    
    private var viewModel: HomeVCProtocol = HomeVCViewModel()
    
    private let sectionTitles = ["Trending Movies", "Trending TV", "Popular",  "Upcoming Movies", "Top rated"]
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell .self, forCellReuseIdentifier: "\(CollectionViewTableViewCell .self)")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupLayouts()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width,
                                                             height: 450))
    }
    
    
    private func setupLayouts() {
        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private func setupNavigationBar() {
        
//        let image = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal)
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "n.circle.fill"), style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = leftBarButton
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .label
    }

}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CollectionViewTableViewCell .self)", for: indexPath) as? CollectionViewTableViewCell 
        
        switch indexPath.section {
        case Sections.trendingMovies.rawValue:
            
            APICaller.shared.getMovies(fromYear: "2022", toYear: "2022") { result in
                switch result {
                case .success(let movies): cell?.setupCell(movies: movies)
                case .failure(let error): print(error)
                }
            }
            
        case Sections.trendingTV.rawValue:
          
            APICaller.shared.getMovies(fromYear: "2020", toYear: "2022") { result in
                switch result {
                case .success(let movies): cell?.setupCell(movies: movies)
                case .failure(let error): print(error)
                }
            }
            
        case Sections.popular.rawValue:
            
            APICaller.shared.getMovies(fromYear: "2018", toYear: "2020") { result in
                switch result {
                case .success(let movies): cell?.setupCell(movies: movies)
                case .failure(let error): print(error)
                }
            }
            
        case Sections.upcomingMovies.rawValue:
            
            APICaller.shared.getMovies(fromYear: "2016", toYear: "2018") { result in
                switch result {
                case .success(let movies): cell?.setupCell(movies: movies)
                case .failure(let error): print(error)
                }
            }
            
        case Sections.topRated.rawValue:
            
            APICaller.shared.getMovies(fromYear: "2014", toYear: "2016") { result in
                switch result {
                case .success(let movies): cell?.setupCell(movies: movies)
                case .failure(let error): print(error)
                }
            }
        default:
            return UITableViewCell()
        }
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
