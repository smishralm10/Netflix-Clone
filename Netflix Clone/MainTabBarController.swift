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
        setUpNavigationControllers()
    }
    
    func setUpNavigationControllers() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let comingSoonVC = UINavigationController(rootViewController: ComingSoonViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let downloadsVC = UINavigationController(rootViewController: DownloadsViewController())
        
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        comingSoonVC.tabBarItem.image = UIImage(systemName: "play.circle")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        homeVC.title = "Home"
        comingSoonVC.title = "Coming Soon"
        searchVC.title = "Search"
        downloadsVC.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, comingSoonVC, searchVC, downloadsVC], animated: true)
        
    }
}

