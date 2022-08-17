//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 29/07/22.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let upComingVC = UINavigationController(rootViewController: UpComingViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let downloadsVC = UINavigationController(rootViewController: DownloadsViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        upComingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        homeVC.title = "Home"
        upComingVC.title = "Up Coming"
        searchVC.title = "Search"
        downloadsVC.title = "Downloads"
        
        tabBar.tintColor = .label
        view.backgroundColor = .black
        
        setViewControllers([homeVC, upComingVC, searchVC, downloadsVC], animated: true)
    }
}

