//
//  HomeVC.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 30.08.22.
//

import UIKit
import SnapKit

final class HomeVC: UIViewController {
    
    private let sectionTitles = ["Trending Movies", "Popular", "Trending TV", "Upcoming Movies", "Top rated"]
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTVC.self, forCellReuseIdentifier: "\(CollectionViewTVC.self)")
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
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CollectionViewTVC.self)", for: indexPath) as? CollectionViewTVC
        cell?.setupCell()
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
