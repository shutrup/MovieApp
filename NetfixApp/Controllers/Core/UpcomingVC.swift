//
//  UpcomingVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 02.08.2022.
//

import UIKit

class UpcomingVC: UIViewController {
    
    private var titles: [Title] = []
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Скоро"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(upcomingTable)
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovie { [weak self] results in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch results{
                case.success(let titles):
                    self.titles = titles
                    self.upcomingTable.reloadData()
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension UpcomingVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.titleRu! , posterURL: title.posterPath! ))
        
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
