//
//  DownloadsVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 02.08.2022.
//

import UIKit

class DownloadsVC: UIViewController {
    
    private var titles: [Titleitem] = [Titleitem]()
    
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Загруженные"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always 
        view.backgroundColor = .systemBackground
        
        view.addSubview(downloadTable)
        downloadTable.delegate = self
        downloadTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("скачали"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
        
    }
    
    private func fetchLocalStorageForDownload(){
        DataPersistenceManager.shared.fetchingTitleFromDataBase { [weak self] results in
            guard let self = self else {return}
                switch results{
                case.success(let titles):
                    self.titles = titles
                    DispatchQueue.main.async {
                        self.downloadTable.reloadData()
                    }
                case.failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
}

extension DownloadsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.titleRu ?? title.name) ?? title.originalTitle!, posterURL: title.posterPath! ))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] results in
                guard let self = self else {return}
                switch results{
                case.success():
                    print("")
                case.failure(let error):
                    print(error)
                }
                self.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let titles = titles[indexPath.row]
        
        guard let titleName = titles.originalTitle ?? titles.originalName else {return}
        
        APICaller.shared.getMovie(with: titleName) {[weak self] results in
            guard let self = self else {return}
            DispatchQueue.main.async { [self] in
                switch results{
                case.success(let videoElement):
                    let vc = TitlePreviewVC()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titles.overview ?? "", genresID: titles.genreIDS ?? []))
                    self.navigationController?.pushViewController(vc, animated: true)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

    }
    
}
