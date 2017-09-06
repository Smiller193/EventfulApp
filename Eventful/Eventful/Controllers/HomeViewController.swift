//
//  HomeViewController.swift
//  Eventful
//
//  Created by Shawn Miller on 7/27/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIPageViewController, UIPageViewControllerDataSource {
    let dropDownLauncher = DropDownLauncher()
        override func viewDidLoad() {
            self.dataSource = self
            super.viewDidLoad()
    
            // setupView()
        }
    
    lazy var viewControllerList: [UINavigationController] = {
        let layout = UICollectionViewFlowLayout()
        let homeFeedController = HomeFeedController(collectionViewLayout: layout)
       let navController = UINavigationController(rootViewController: homeFeedController)
        let profileView = ProfileeViewController(collectionViewLayout: layout)
        let profileViewNavController = UINavigationController(rootViewController: profileView)
        let searchController = EventSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = UINavigationController(rootViewController: searchController)
    }()
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

