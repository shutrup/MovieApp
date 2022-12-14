//
//  HomeVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 02.08.2022.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {
    
    private var randomSelectedMovie: Title?
    private var headerView: HeroHeaderView?
    
    private let sectionTitles: [String] = ["Популярные фильмы", "Популярные сериалы", "Популярные","Предстоящие фильмы", "Самые популярные"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.id)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width , height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(showProfileScreen)),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done,target: self,action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
     
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    @objc func showLoginVc(){
        let vc = AuthVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showProfileScreen(){
        if let user = Auth.auth().currentUser {
            FirestoreService.shared.getUserData(user: user) { result in
                switch result {
                case .success(let users):
                    let vc = ProfileScreenVC(currentUser: users)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }else {
            return
        }
    }
    
    private func configureHeroHeaderView(){
        APICaller.shared.getTrendingMovies { [weak self] results in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch results{
                case.success(let titles):
                    let selectedTitle = titles.randomElement()
                    self.randomSelectedMovie = selectedTitle
                    self.headerView?.configure(with: TitleViewModel(titleName: (selectedTitle?.titleRu!)!, posterURL: selectedTitle?.posterPath ?? ""))
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension HomeVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.id, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
            
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            
            APICaller.shared.getTrendingMovies { results in
                switch results{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            
            APICaller.shared.getTrendingTvs {  results in
                switch results{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        case Sections.Popular.rawValue:
            
            APICaller.shared.getPopular { results in
                switch results{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        case Sections.Upcoming.rawValue:
            
            APICaller.shared.getUpcomingMovie { results in
                switch results{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        case Sections.TopRated.rawValue:
            
            APICaller.shared.getTopRated {  results in
                switch results{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
        default:
            return UITableViewCell()
        }
        return cell
        
    }
    
}

extension HomeVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeVC: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self]  in
            guard let self = self else {return}
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
