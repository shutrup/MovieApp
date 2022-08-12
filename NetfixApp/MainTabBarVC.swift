//
//  ViewController.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 02.08.2022.
//

import UIKit

class MainTabBarVC: UITabBarController {
    private let currentUser: Users
    
    init(current: Users){
        self.currentUser = current
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let upcomingVC = UINavigationController(rootViewController: UpcomingVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let downloadsVC = UINavigationController(rootViewController: DownloadsVC())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.title = "Главная"
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        upcomingVC.title = "Скоро"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchVC.title = "Поиск"
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        downloadsVC.title = "Загруженный"
        
        
        tabBar.tintColor = .label
        setViewControllers([homeVC,upcomingVC,searchVC,downloadsVC], animated: true)
        
    }


}

