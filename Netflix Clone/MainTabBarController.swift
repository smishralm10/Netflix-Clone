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
        tabBar.tintColor = .label
    }
    
    init(controllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        setViewControllers(controllers, animated: true)
    }
    
    required init(coder: NSCoder) {
        fatalError("Not Supported!")
    }
}

