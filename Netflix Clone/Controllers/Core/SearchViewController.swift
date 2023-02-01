//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Ali Görkem Aksöz on 31.01.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = []
    
    private let searchTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SerchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(searchTableView)
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name ?? "Unknwon"
        let posterPath = titles[indexPath.row].poster_path ?? "Unkown"
        cell.configure(with: TitleViewModel(titleName: title, posterURL: posterPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultController = searchController.searchResultsController as? SerchResultsViewController else { return }
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.searchResultCollectionView.reloadData()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
        
    }
    
    
}
