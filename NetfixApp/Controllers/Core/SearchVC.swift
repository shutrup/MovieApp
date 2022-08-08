//
//  SearchVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 02.08.2022.
//

import UIKit

class SearchVC: UIViewController {

    private var titles: [Title] = [Title]()
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Поиск фильмов"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Поиск"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { [weak self] results in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch results{
                case.success(let titles):
                    self.titles = titles
                    self.discoverTable.reloadData()
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
}

extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.titleRu!, posterURL: title.posterPath!)
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let titles = titles[indexPath.row]
        
        guard let titleName = titles.titleRu else {return}
        
        APICaller.shared.getMovie(with: titleName) {[weak self] results in
            guard let self = self else {return}
            DispatchQueue.main.async { [self] in
                switch results{
                case.success(let videoElement):
                    let vc = TitlePreviewVC()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titles.overview ?? "", genresID: titles.genreIDS!))
                    self.navigationController?.pushViewController(vc, animated: true)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

extension SearchVC: UISearchResultsUpdating , SearchResultsVCDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsVC else {
            return
        }
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) {results in
                DispatchQueue.main.async {
                switch results{
                case.success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case.failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
    func SearchResultsVCDidTapElement(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
