//
//  HomeVCViewModel.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 6.09.22.
//

import Foundation

enum Sections: Int {
    case trendingMovies = 0
    case trendingTV = 1
    case popular = 2
    case upcomingMovies = 3
    case topRated = 4
}

protocol HomeVCProtocol {
    var sectionTitles: [String] { get }
    var moviesDict: [Sections: [Movie]] { get set }
    var contentDidChanged: (() -> Void)? { get set }
    func loadDataFromAPI()
    func setupCollectionViewTableViewCell(indexPath: IndexPath, cell: SectionTableViewCell?)
    
}

final class HomeVCViewModel: HomeVCProtocol {
    var sectionTitles = ["Trending Movies", "Trending TV", "Popular",  "Upcoming Movies", "Top rated"]
    var moviesDict: [Sections: [Movie]] = [:] {
        didSet {
            contentDidChanged?()
        }
    }
    
    var contentDidChanged: (() -> Void)?
    
    func loadDataFromAPI() {
        loadCategory(fromYear: "2022", toYear: "2022", to: Sections.trendingMovies)
        loadCategory(fromYear: "2000", toYear: "2022", to: Sections.trendingTV)
        loadCategory(fromYear: "2018", toYear: "2020", to: Sections.popular)
        loadCategory(fromYear: "2016", toYear: "2018", to: Sections.upcomingMovies)
        loadCategory(fromYear: "2014", toYear: "2016", to: Sections.topRated)
    }
    
    private func loadCategory(fromYear: String, toYear: String, to section: Sections) {
        NetworkService.shared.getMovies(fromYear: fromYear, toYear: toYear) { result in
            switch result {
            case .success(let movies): self.moviesDict[section] = movies
            case .failure(let error): print(error)
            }
        }
    }
    
    
        func setupCollectionViewTableViewCell(indexPath: IndexPath, cell: SectionTableViewCell?) {
            switch indexPath.section {
            case Sections.trendingMovies.rawValue:
                cell?.setupCell(movies: moviesDict[Sections.trendingMovies] ?? [])
            case Sections.trendingTV.rawValue:
                cell?.setupCell(movies: moviesDict[Sections.trendingTV] ?? [])
            case Sections.popular.rawValue:
                cell?.setupCell(movies: moviesDict[Sections.popular] ?? [])
            case Sections.upcomingMovies.rawValue:
                cell?.setupCell(movies: moviesDict[Sections.upcomingMovies] ?? [])
            case Sections.topRated.rawValue:
                cell?.setupCell(movies: moviesDict[Sections.topRated] ?? [])
            default:
                break
            }
        
    }
    
}
